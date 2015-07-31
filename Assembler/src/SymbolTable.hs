module SymbolTable where

import MMix_Parser
import Registers
import qualified Data.Map.Lazy as M
import Data.Char (chr)

type Table = M.Map String Int
type BaseTable = M.Map Char Int
type SymbolTable = M.Map Identifier RegisterAddress

createSymbolTable :: Either String [Line] -> Either String SymbolTable
createSymbolTable (Left msg) = Left msg
createSymbolTable (Right lines) =
        let symbols = foldl getSymbol (Right M.empty) lines
            regs = createRegisterTable $ Right lines
        in symbols

getSymbol :: Either String SymbolTable -> Line -> Either String SymbolTable
getSymbol (Left errorMsg) _ = Left errorMsg
getSymbol (Right table) (LabelledPILine pi@(GregAuto) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Just pi) table
getSymbol (Right table) (LabelledPILine pi@(GregSpecific _) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Just pi) table
getSymbol (Right table) (LabelledPILine _ ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Nothing) table
getSymbol (Right table) (LabelledOpCodeLine _ _ ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Nothing) table
getSymbol (Right table) _ = Right $ table


determineBaseAddressAndOffset :: (M.Map Int Char) -> RegisterAddress -> Maybe(Char, Int)
determineBaseAddressAndOffset rfa (a, Nothing) =
  case (M.lookupLE a rfa) of
    Just(address, register) -> Just(register, a - address)
    _ -> Nothing
determineBaseAddressAndOffset _ _ = Nothing

mapSymbolToAddress :: (M.Map Identifier RegisterAddress) -> (M.Map Char Int) -> Line -> Maybe(Char, Int)
--mapSymbolToAddress symbols table (PlainOpCodeLine _ (ListElementId r t) _)
--     | M.member t symbols = determineBaseAddressAndOffset registersByAddress requiredAddress
--     | otherwise = Nothing
--     where registersByAddress = registersFromAddresses table
--           requiredAddress = symbols M.! t
--mapSymbolToAddress symbols table (LabelledOpCodeLine _ (ListElementId r t) _ _)
--     | M.member t symbols = determineBaseAddressAndOffset registersByAddress requiredAddress
--     | otherwise = Nothing
--     where registersByAddress = registersFromAddresses table
--           requiredAddress = symbols M.! t
mapSymbolToAddress _ _ _ = Nothing