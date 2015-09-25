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
genCodeForLine symbols registers (LabelledOpCodeLine opcode operands _ address simple_code) = genOpCodeOutput symbols registers opcode operands address simple_code
genCodeForLine symbols registers (PlainOpCodeLine opcode operands address simple_code) = genOpCodeOutput symbols registers opcode operands address simple_code
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
genPICodeOutput symbols registers address i1@(Expr (ExpressionIdentifier _)) i2@(Expr (ExpressionIdentifier _)) = genOpCodeOutput symbols registers 193 operands address True
    where operands = i1 : i2 : (Expr (ExpressionNumber 0)) : []
genPICodeOutput symbols registers address i1@(Expr (ExpressionIdentifier _)) i2@(Expr (ExpressionNumber _)) = genOpCodeOutput symbols registers 227 operands address True
    where operands = i1 : (Expr (ExpressionNumber 0)) : i2 : []
genPICodeOutput symbols registers address r1@(Register _) r2@(Register _) = genOpCodeOutput symbols registers 192 operands address True
    where operands = r1 : r2 : (Expr (ExpressionNumber 0)) : []
genPICodeOutput symbols registers address r1@(Register _) r2@(Expr (ExpressionNumber _)) = genOpCodeOutput symbols registers 227 operands address True
    where operands = r1 : r2 : []
genPICodeOuput _ _ _ _ _ = Nothing

genOpCodeOutput :: SymbolTable -> RegisterTable -> Int -> [OperatorElement] -> Int -> Bool -> Maybe CodeLine
genOpCodeOutput symbols registers 254 operands address _ = Just(CodeLine {cl_address = address, cl_size = 4, cl_code = code})
    where code = splitSpecialRegisters symbols operands
genOpCodeOutput symbols registers opcode operands address False 
    | opcode >= 60 && opcode <= 95 = Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + local_adjustment)) : code})
    | opcode == 240 = Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + jump_adjustment)) : jump_code})
    | opcode == 34 = case splitOperandsAddress symbols registers operands of
                        Just(address_adjustment, address_code) -> Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + address_adjustment)) : address_code})
                        _ -> Nothing
    | otherwise = case splitOperands symbols registers operands of
        Just((adjustment,params)) -> Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + adjustment)) : params})
        _ -> Nothing
      where (local_adjustment, code) = splitLocalOperands symbols operands address
            (jump_adjustment, jump_code) = jumpOperands symbols operands address
genOpCodeOutput symbols registers opcode operands address True =
    case splitOperands symbols registers operands of
        Just((adjustment,params)) -> Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr opcode) : params})
        _ -> Nothing

localLabelOffset :: Int -> Int -> (Int, Int)
localLabelOffset current required
    | required < current = (1, (quot (current - required) 4))
    | otherwise          = (0, (quot (required - current) 4))

formatElement :: SymbolTable -> OperatorElement -> Char
formatElement _ (ByteLiteral b) = b
formatElement _ (PseudoCode pc) = chr pc
formatElement _ (Register r) = r
formatElement st (Expr x@(ExpressionIdentifier id)) =
    case M.lookup id st of
        (Just (_, Just (IsRegister r))) -> chr r
        (Just (_, Just (IsIdentifier r))) -> formatElement st (Expr (ExpressionIdentifier r))
        otherwise -> evaluateByteToChar st x
formatElement st (Expr x) = evaluateByteToChar st x

evaluateByteToChar :: SymbolTable -> ExpressionEntry -> Char
evaluateByteToChar st x = chr digit
    where plain_digit = (E.evaluate x 0 st)
          digit = if plain_digit < 0
                      then 256 + plain_digit
                      else plain_digit

jumpOperands :: SymbolTable -> [OperatorElement] -> Int -> (Int, String)
jumpOperands symbols ((Ident id):[]) address = (adjustment, code)
    where ro = getSymbolAddress symbols id
          (adjustment, offset) = localLabelOffset address ro
          b2 = rem offset 256
          q2 = quot offset 256
          b1 = rem q2 256
          b0 = quot q2 256
          code = (chr b0) : (chr b1) : (chr b2) : []

splitOperandsAddress :: SymbolTable -> RegisterTable -> [OperatorElement] -> Maybe(AdjustedOperands)
splitOperandsAddress symbols registers (x:(Expr (ExpressionNumber y)):[]) = Just(1, code)
    where registersByAddress = registersFromAddresses registers
          Just(reg, offset) = determineBaseAddressAndOffset registersByAddress (y, Nothing)
          formatted_x = formatElement symbols x
          code = formatted_x : reg : (chr offset) : []
splitOperandsAddress symbols registers (x:Expr (ExpressionIdentifier y):[]) =
    case mapSymbolToAddress symbols registers y of
       Just(y_reg, y_offset) -> Just(1, code)
          where formatted_x = formatElement symbols x
                code = formatted_x : y_reg : (chr y_offset) : []
       otherwise -> Nothing
splitOperandsAddress _ _ _ = Nothing

splitLocalOperands :: SymbolTable -> [OperatorElement] -> Int -> (Int, String)
splitLocalOperands symbols (x:(Ident id):[]) address = (adjustment, code)
    where ro = getSymbolAddress symbols id
          formatted_x = formatElement symbols x
          (adjustment, offset) = localLabelOffset address ro
          b1 = chr (quot offset 256)
          b2 = chr (rem  offset 256)
          code = formatted_x : b1 : b2 : []

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
    where ops = map chr $ drop 2 $ char4 y
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
splitOperands symbols registers (x : y : z@(Expr (ExpressionNumber _)) : []) = Just(1, code)
    where formatted_x = formatElement symbols x
          formatted_y = formatElement symbols y
          formatted_z = formatElement symbols z
          code = formatted_x : formatted_y : formatted_z : []
splitOperands symbols registers (x : y : z : []) = Just(0, code)
    where formatted_x = formatElement symbols x
          formatted_y = formatElement symbols y
          formatted_z = formatElement symbols z
          code = formatted_x : formatted_y : formatted_z : []
splitOperands _ _ _ = Nothing

splitSpecialRegisters :: SymbolTable -> [OperatorElement] -> String
splitSpecialRegisters st (x:(Expr (ExpressionIdentifier (Id special))):[]) = (chr 254) : reg : special_register_to_operand special
    where reg = formatElement st x

special_register_to_operand :: String -> String
special_register_to_operand "rA"  = (chr 0) : (chr 21) : []
special_register_to_operand "rB"  = (chr 0) : (chr 0)  : []
special_register_to_operand "rC"  = (chr 0) : (chr 8)  : []
special_register_to_operand "rD"  = (chr 0) : (chr 1)  : []
special_register_to_operand "rE"  = (chr 0) : (chr 2)  : []
special_register_to_operand "rF"  = (chr 0) : (chr 22) : []
special_register_to_operand "rG"  = (chr 0) : (chr 19) : []
special_register_to_operand "rH"  = (chr 0) : (chr 3)  : []
special_register_to_operand "rI"  = (chr 0) : (chr 12) : []
special_register_to_operand "rJ"  = (chr 0) : (chr 4)  : []
special_register_to_operand "rK"  = (chr 0) : (chr 15) : []
special_register_to_operand "rL"  = (chr 0) : (chr 20) : []
special_register_to_operand "rM"  = (chr 0) : (chr 5)  : []
special_register_to_operand "rN"  = (chr 0) : (chr 9)  : []
special_register_to_operand "rO"  = (chr 0) : (chr 10) : []
special_register_to_operand "rP"  = (chr 0) : (chr 23) : []
special_register_to_operand "rQ"  = (chr 0) : (chr 16) : []
special_register_to_operand "rR"  = (chr 0) : (chr 6)  : []
special_register_to_operand "rS"  = (chr 0) : (chr 11) : []
special_register_to_operand "rT"  = (chr 0) : (chr 13) : []
special_register_to_operand "rU"  = (chr 0) : (chr 17) : []
special_register_to_operand "rV"  = (chr 0) : (chr 18) : []
special_register_to_operand "rW"  = (chr 0) : (chr 24) : []
special_register_to_operand "rX"  = (chr 0) : (chr 25) : []
special_register_to_operand "rY"  = (chr 0) : (chr 26) : []
special_register_to_operand "rZ"  = (chr 0) : (chr 27) : []
special_register_to_operand "rBB" = (chr 0) : (chr 7)  : []
special_register_to_operand "rTT" = (chr 0) : (chr 14) : []
special_register_to_operand "rWW" = (chr 0) : (chr 28) : []
special_register_to_operand "rXX" = (chr 0) : (chr 29) : []
special_register_to_operand "rYY" = (chr 0) : (chr 30) : []
special_register_to_operand "rZZ" = (chr 0) : (chr 31) : []

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
          num_bs = char4 . length $ bs
          bh = blockDetails (O.sort bs) []
          details = num_bs ++ bh

encodeRegisterTable :: RegisterTable -> [Int]
encodeRegisterTable regs = size ++ vals
    where vals = M.foldrWithKey encodeRegister [] regs
          size = char4 $ M.size regs

encodeRegister :: Char -> ExpressionEntry -> [Int] -> [Int]
encodeRegister r (ExpressionNumber v) a = nextPart ++ a
    where nextPart = (ord r) : char8 v

blockDetails :: [BlockSummary] -> [Int] -> [Int]
blockDetails [] final = final
blockDetails (currentBlock:rest) acc = blockDetails rest newAcc
    where newAcc = acc ++ (blockDetail currentBlock)

blockDetail :: BlockSummary -> [Int]
blockDetail (start, size, code) = startc ++ sizec ++ code
    where startc = char8 start
          sizec  = char4 size

char4 :: Int -> [Int]
char4 val = char4tail [] val

char4tail :: [Int] -> Int -> [Int]
char4tail acc val
    | (val == -1) && ((length acc) == 4) = acc
    | (val < 0) = case (divMod val 256) of
                     (m, r) -> char4tail (r : acc) m
    | (val == 0) && ((length acc) == 4) = acc
    | (val == 0) = char4tail (0 : acc) val
    | otherwise = case (divMod val 256) of
        (m, r) -> char4tail (r : acc) m

char8 :: Int -> [Int]
char8 val = char8tail [] val

char8tail :: [Int] -> Int -> [Int]
char8tail acc val
    | (val == -1) && ((length acc) == 8) = acc
    | (val < 0) = case (divMod val 256) of
                     (m, r) -> char8tail (r : acc) m
    | (val == 0) && ((length acc) == 8) = acc
    | (val == 0) = char8tail (0 : acc) val
    | otherwise = case (divMod val 256) of
        (m, r) -> char8tail (r : acc) m

