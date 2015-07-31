module CodeGen where

import SymbolTable
import qualified Data.Map.Lazy as M
import MMix_Parser
import Data.Char (chr)
import Registers

genCodeForLine :: (M.Map Identifier RegisterAddress) -> (M.Map Char Int) -> Line -> Maybe(Int, Int, [Char])
--genCodeForLine symbols registers ln@(PlainOpCodeLine opcode (ListElementId (Register r) _) address) =
--    case (mapSymbolToAddress symbols registers ln) of
--        Just(base, offset) -> Just(address, 4, (chr opcode) : (chr r) : base : (chr offset) : [])
--        _ -> Nothing
--genCodeForLine symbols registers ln@(PlainOpCodeLine opcode (ListIdElement _ (Register r)) address) =
--    case (mapSymbolToAddress symbols registers ln) of
--        Just(base, offset) -> Just(address, 4, (chr opcode) : (chr r) : base : (chr offset) : [])
--        _ -> Nothing
--genCodeForLine symbols registers ln@(PlainOpCodeLine opcode (List3Elements first second third) address) = Just(address, 4, op : p1 : p2 : p3 : [])
--    where op = chr opcode
--          p1 = formatElement first
--          p2 = formatElement second
--          p3 = formatElement third
--genCodeForLine symbols registers ln@(LabelledOpCodeLine opcode (ListElementId (Register r) _) _ address) =
--    case (mapSymbolToAddress symbols registers ln) of
--        Just(base, offset) -> Just(address, 4, (chr opcode) : (chr r) : base : (chr offset) : [])
--        _ -> Nothing
--genCodeForLine symbols registers ln@(LabelledOpCodeLine opcode (ListIdElement _ (Register r)) _ address) =
--    case (mapSymbolToAddress symbols registers ln) of
--        Just(base, offset) -> Just(address, 4, (chr opcode) : (chr r) : base : (chr offset) : [])
--        _ -> Nothing
--genCodeForLine symbols registers ln@(LabelledOpCodeLine opcode (List3Elements first second third) _ address) = Just(address, 4, op : p1 : p2 : p3 : [])
--    where op = chr opcode
--          p1 = formatElement first
--          p2 = formatElement second
--          p3 = formatElement third
genCodeForLine _ _ (LabelledPILine (ByteArray arr) _ address) = Just(address, s, arr)
    where s = length arr
genCodeForLine _ _ _ = Nothing

formatElement (ByteLiteral b) = b
formatElement (PseudoCode pc) = chr pc
formatElement (Register r) = r
