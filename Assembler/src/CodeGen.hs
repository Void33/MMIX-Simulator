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
genCodeForLine _ _ _ = Nothing

genOpCodeOutput symbols registers opcode operands address =
    case splitOperands symbols registers operands of
        Just((adjustment,params)) -> Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + adjustment)) : params})
        _ -> Nothing

formatElement :: OperatorElement -> Char
formatElement (ByteLiteral b) = b
formatElement (PseudoCode pc) = chr pc
formatElement (Register r) = r
formatElement (Expr x) = chr (E.evaluate x)

splitOperands :: SymbolTable -> RegisterTable -> [OperatorElement] -> Maybe(AdjustedOperands)
splitOperands symbols registers ((Register x):(Expr (ExpressionIdentifier y)):[]) =
    case ro of
        Just((base, offset)) -> Just(1, x : base : (chr offset) : [])
        otherwise -> Nothing
        where ro = mapSymbolToAddress symbols registers y
splitOperands symbols registers (x : y : z : []) = Just(0, output)
    where output = (formatElement x) : (formatElement y) : (formatElement x) : []
splitOperands _ _ _ = Nothing

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

encodeRegister r v a = nextPart ++ a
    where nextPart = (ord r) : char8 v

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