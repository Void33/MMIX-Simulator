module CodeGen where

import SymbolTable
import qualified Data.Map.Lazy as M
import qualified Data.List.Ordered as O
import qualified Data.ByteString.Lazy as B
import Data.Binary
import MMix_Parser
import Data.Char (chr, ord)
import Registers
import Expressions as E
import Numeric (showHex)
import DataTypes

type AdjustedOperands = (Int, String)

data CodeLine = CodeLine { cl_address :: Int, cl_size :: Int, cl_code :: [Char] }
                deriving(Show)

instance Eq CodeLine where
    (CodeLine address1 _ _) == (CodeLine address2 _ _) = address1 == address2
instance Ord CodeLine where
    (CodeLine address1 _ _) `compare` (CodeLine address2 _ _) = address1 `compare` address2

encodeProgram :: Either String [CodeLine] -> Either String RegisterTable -> Either String String
encodeProgram (Left code_error) _ = Left code_error
encodeProgram _ (Left register_error) = Left register_error
encodeProgram (Right code) (Right regs) = Right $ map chr $ encodeProgramInt code regs

genCodeForLine :: SymbolTable -> RegisterTable -> Line -> Maybe(CodeLine)
genCodeForLine symbols registers (LabelledOpCodeLine opcode operands _ address) = genOpCodeOutput symbols registers opcode operands address
genCodeForLine symbols registers (PlainOpCodeLine opcode operands address) = genOpCodeOutput symbols registers opcode operands address
genCodeForLine _ _ (LabelledPILine (ByteArray arr) _ address) = Just(CodeLine {cl_address = address, cl_size = s, cl_code = arr})
    where s = length arr
genCodeForLine _ _ (LabelledPILine (WydeArray arr) _ address) = Just(CodeLine {cl_address = address, cl_size = s, cl_code = wyde_array})
    where wyde_array = make_bytes arr 2
          s = length wyde_array
genCodeForLine _ _ (LabelledPILine (TetraArray arr) _ address) = Just(CodeLine {cl_address = address, cl_size = s, cl_code = wyde_array})
    where wyde_array = make_bytes arr 4
          s = length wyde_array
genCodeForLine _ _ (LabelledPILine (OctaArray arr) _ address) = Just(CodeLine {cl_address = address, cl_size = s, cl_code = wyde_array})
    where wyde_array = make_bytes arr 8
          s = length wyde_array
genCodeForLine symbols registers (LabelledPILine (Set (e1, e2)) _ address) =
    genPICodeOutput symbols registers address e1 e2
genCodeForLine symbols registers (PlainPILine (Set (e1, e2)) address) =
    genPICodeOutput symbols registers address e1 e2
genCodeForLine _ _ _ = Nothing

genPICodeOutput :: SymbolTable -> RegisterTable -> Int -> OperatorElement -> OperatorElement -> Maybe(CodeLine)
genPICodeOutput symbols registers address i1@(Expr (ExpressionIdentifier _)) i2@(Expr (ExpressionIdentifier _)) = genOpCodeOutput symbols registers 193 operands address
    where operands = i1 : i2 : (Expr (ExpressionNumber 0)) : []
genPICodeOutput symbols registers address i1@(Expr (ExpressionIdentifier _)) i2@(Expr (ExpressionNumber _)) = genOpCodeOutput symbols registers 227 operands address
    where operands = i1 : i2 : (Expr (ExpressionNumber 0)) : []
genPICodeOutput symbols registers address r1@(Register _) r2@(Register _) = genOpCodeOutput symbols registers 192 operands address
    where operands = r1 : r2 : (Expr (ExpressionNumber 0)) : []
genPICodeOutput symbols registers address r1@(Register _) r2@(Expr (ExpressionNumber _)) = genOpCodeOutput symbols registers 227 operands address
    where operands = r1 : r2 : []
genPICodeOuput _ _ _ _ _ = Nothing

genOpCodeOutput :: SymbolTable -> RegisterTable -> Int -> [OperatorElement] -> Int -> Maybe CodeLine
genOpCodeOutput symbols registers opcode operands address =
    case splitOperands symbols registers operands of
        Just((adjustment,params)) -> Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + adjustment)) : params})
        _ -> Nothing

formatElement :: SymbolTable -> OperatorElement -> Char
formatElement _ (ByteLiteral b) = b
formatElement _ (PseudoCode pc) = chr pc
formatElement _ (Register r) = r
formatElement st (Expr x@(ExpressionIdentifier id)) =
    case M.lookup id st of
        (Just (_, Just (IsRegister r))) -> chr r
        otherwise -> chr (E.evaluate x 0 st)
formatElement st (Expr x) = chr (E.evaluate x 0 st)

splitOperands :: SymbolTable -> RegisterTable -> [OperatorElement] -> Maybe(AdjustedOperands)
splitOperands symbols registers ((Ident id):[]) = Just(1, code)
    where ro = mapSymbolToAddress symbols registers id
          code = case ro of
                     Just((base,offset)) -> (chr 0) : base : (chr offset) : []
splitOperands symbols registers ((Ident id1):(Expr (ExpressionIdentifier id2)):[]) = Just(1, code)
    where ro1 = mapSymbolToAddress symbols registers id1
          ro2 = mapSymbolToAddress symbols registers id2
          code = case (ro1, ro2) of
                     (Just((base1,_)), Just((base2,offset2))) -> base1 : base2 : (chr offset2) : []
                     otherwise -> []
splitOperands symbols registers (x:(Expr (ExpressionNumber y)):[]) = Just(1, code)
    where ops = map chr $ drop 2 $ char8 y
          formatted_x = formatElement symbols x
          code = formatted_x : ops
splitOperands symbols registers (x:(Ident id):[]) = Just(1, code)
    where ro = mapSymbolToAddress symbols registers id
          formatted_x = formatElement symbols x
          code = case ro of
                     Just((base,offset)) -> formatted_x : base : (chr offset) : []
                     otherwise -> []
splitOperands symbols registers (x:(Expr (ExpressionIdentifier id)):[]) = Just(1, code)
    where ro = mapSymbolToAddress symbols registers id
          formatted_x = formatElement symbols x
          code = case ro of
                     Just((base,offset)) -> formatted_x : base : (chr offset) : []
                     otherwise -> []
splitOperands symbols registers (x : y : z : []) = Just(0, code)
    where formatted_x = formatElement symbols x
          formatted_y = formatElement symbols y
          formatted_z = formatElement symbols z
          code = formatted_x : formatted_y : formatted_z : []
splitOperands _ _ _ = Nothing


make_bytes :: [Char] -> Int -> [Char]
make_bytes arr size = make_inner_bytes size arr []

make_inner_bytes _ [] acc = acc
make_inner_bytes size (x:xs) acc = make_inner_bytes size xs new_acc
    where extended_byte = make_byte x size []
          new_acc = acc ++ extended_byte

make_byte :: Char -> Int -> [Char] -> [Char]
make_byte _ 0 acc = reverse acc
make_byte b 1 acc = make_byte b 0 (b : acc)
make_byte b n acc = make_byte b (n-1) ((chr 0):acc)

type BlockSummary = (Int, Int, [Int]) -- Starting Address, Size, Data in block

blocks :: [CodeLine] -> [BlockSummary]
blocks [] = []
blocks lines = nextBlock [] (O.sort lines)

nextBlock :: [BlockSummary] -> [CodeLine] -> [BlockSummary]
nextBlock [] (currentLine:rest) = nextBlock [((cl_address currentLine), (cl_size currentLine), (map ord (cl_code currentLine)))] rest
nextBlock (currentBlock:blocks) (currentLine:rest)
    | (start + size) == (cl_address currentLine) = nextBlock (updateBlock:blocks) rest
    | otherwise = nextBlock (newBlock:currentBlock:blocks) rest
        where (start, size, code) = currentBlock
              extraCode = map ord (cl_code currentLine)
              updatedCode = code ++ extraCode
              updateBlock = (start, size + (cl_size currentLine), updatedCode)
              newBlock = ((cl_address currentLine), (cl_size currentLine), extraCode)
nextBlock result [] = O.sort result

encodeProgramInt :: [CodeLine] -> RegisterTable -> [Int]
encodeProgramInt prog regs = hdr ++ tbl
    where hdr = header prog
          tbl = encodeRegisterTable regs

header :: [CodeLine] -> [Int]
header program = details
    where bs = blocks program
          num_bs = char8 . length $ bs
          bh = blockDetails (O.sort bs) []
          details = num_bs ++ bh

encodeRegisterTable :: RegisterTable -> [Int]
encodeRegisterTable regs = size ++ vals
    where vals = M.foldrWithKey encodeRegister [] regs
          size = char8 $ M.size regs

encodeRegister :: Char -> ExpressionEntry -> [Int] -> [Int]
encodeRegister r v a = nextPart ++ a
    where nextPart = (ord r) : [1] --char8 v

blockDetails :: [BlockSummary] -> [Int] -> [Int]
blockDetails [] final = final
blockDetails (currentBlock:rest) acc = blockDetails rest newAcc
    where newAcc = acc ++ (blockDetail currentBlock)

blockDetail :: BlockSummary -> [Int]
blockDetail (start, size, code) = startc ++ sizec ++ code
    where startc = char8 start
          sizec  = char8 size

char8 :: Int -> [Int]
char8 val = char8tail [] val

char8tail :: [Int] -> Int -> [Int]
char8tail acc val
    | (val == 0) && ((length acc) == 4) = acc
    | (val == 0) = char8tail (0 : acc) val
    | otherwise = case (divMod val 256) of
        (m, r) -> char8tail (r : acc) m