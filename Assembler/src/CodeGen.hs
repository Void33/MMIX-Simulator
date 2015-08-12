module CodeGen where

import SymbolTable
import qualified Data.Map.Lazy as M
import qualified Data.List.Ordered as O
import qualified Data.ByteString.Lazy as B
import Data.Binary
import MMix_Parser
import Data.Char (chr)
import Registers
import Expressions as E

type AdjustedOperands = (Int, String)

data CodeLine = CodeLine { cl_address :: Int, cl_size :: Int, cl_code :: [Char] }
                deriving(Show)

instance Eq CodeLine where
    (CodeLine address1 _ _) == (CodeLine address2 _ _) = address1 == address2
instance Ord CodeLine where
    (CodeLine address1 _ _) `compare` (CodeLine address2 _ _) = address1 `compare` address2

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

type BlockSummary = (Int, Int) -- Starting Address, Size

blocks :: [CodeLine] -> [BlockSummary]
blocks [] = []
blocks lines = nextBlock [] (O.sort lines)

nextBlock :: [BlockSummary] -> [CodeLine] -> [BlockSummary]
nextBlock [] (currentLine:rest) = nextBlock [((cl_address currentLine), (cl_size currentLine))] rest
nextBlock (currentBlock:blocks) (currentLine:rest)
    | (start + size) == (cl_address currentLine) = nextBlock (updateBlock:blocks) rest
    | otherwise = nextBlock (newBlock:currentBlock:blocks) rest
        where (start, size) = currentBlock
              updateBlock = (start, size + (cl_size currentLine))
              newBlock = ((cl_address currentLine), (cl_size currentLine))
nextBlock result [] = O.sort result

--header :: [CodeLine] -> String
header program = details
    where bs = blocks program
          num_bs = length bs
          first = encode num_bs
          bh = blockHeaders (O.sort bs) B.empty
          details = B.append first bh

blockHeaders :: [BlockSummary] -> B.ByteString -> B.ByteString
blockHeaders (currentBlock:rest) acc = blockHeaders rest $ B.append (blockHeader currentBlock) acc
blockHeaders [] final = final

blockHeader :: BlockSummary -> B.ByteString
blockHeader (start, size) = B.append start_b size_b
    where start_b = encode start
          size_b = encode size