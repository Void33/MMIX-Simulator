module SymbolTable where

import MMix_Parser
import qualified Data.Map.Lazy as M
import Data.Char (chr)

type Table = M.Map String Int

type RegisterAddress = (Int, Maybe PseudoInstruction)

createSymbolTable :: Either String [Line] -> Either String (M.Map String RegisterAddress)
createSymbolTable (Left msg) = Left msg
createSymbolTable (Right lines) =
        let symbols = foldl getSymbol (Right M.empty) lines
            regs = createRegisterTable $ Right lines
        in symbols

getSymbol :: Either String (M.Map String RegisterAddress) -> Line -> Either String (M.Map String RegisterAddress)
getSymbol (Left errorMsg) _ = Left errorMsg
getSymbol (Right table) (LabelledPILine pi@(GregAuto) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ ident
          | otherwise = Right $ M.insert ident (address, Just pi) table
getSymbol (Right table) (LabelledPILine pi@(GregSpecific _) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ ident
          | otherwise = Right $ M.insert ident (address, Just pi) table
getSymbol (Right table) (LabelledPILine _ ident address)
          | M.member ident table = Left $ "Identifier already present " ++ ident
          | otherwise = Right $ M.insert ident (address, Nothing) table
getSymbol (Right table) (LabelledOpCodeLine _ _ ident address)
          | M.member ident table = Left $ "Identifier already present " ++ ident
          | otherwise = Right $ M.insert ident (address, Nothing) table
getSymbol (Right table) _ = Right $ table

createRegisterTable :: Either String [Line] -> Either String (M.Map Char Int)
createRegisterTable (Left msg) = Left msg
createRegisterTable (Right lines) = foldl getRegister (Right M.empty) lines

getRegister :: Either String (M.Map Char Int) -> Line -> Either String (M.Map Char Int)
getRegister (Left msg) _ = Left msg
getRegister (Right table) (LabelledPILine pi@(GregAuto) _ _) = Left "Nonspecific register found"
getRegister (Right table) (LabelledPILine pi@(GregSpecific register) _ address)
        | M.member register table = Left $ "Duplicate register definition " ++ (show register)
        | otherwise = Right $ M.insert register address table
getRegister (Right table) (PlainPILine pi@(GregAuto) address) = Left "Nonspecific register found"
getRegister (Right table) (PlainPILine pi@(GregSpecific register) address)
        | M.member register table = Left $ "Duplicate register definition " ++ (show register)
        | otherwise = Right $ M.insert register address table
getRegister (Right table) (LabelledOpCodeLine _ _ "Main" address)
        | M.member (chr 255) table = Left $ "Duplicate Main section definition"
        | otherwise = Right $ M.insert (chr 255) address table
getRegister (Right table) _ = Right $ table

registersFromAddresses :: (M.Map Char Int) -> (M.Map Int Char)
registersFromAddresses orig = M.foldrWithKey addNextRegister M.empty orig

addNextRegister :: Char -> Int -> (M.Map Int Char) -> (M.Map Int Char)
addNextRegister k v orig = M.insert v k orig

determineBaseAddressAndOffset :: (M.Map Int Char) -> RegisterAddress -> Maybe(Char, Int)
determineBaseAddressAndOffset rfa (a, Nothing) =
  case (M.lookupLE a rfa) of
    Just(address, register) -> Just(register, a - address)
    _ -> Nothing
determineBaseAddressAndOffset _ _ = Nothing

mapSymbolToAddress :: (M.Map String RegisterAddress) -> (M.Map Char Int) -> Line -> Maybe(Char, Int)
mapSymbolToAddress symbols table (PlainOpCodeLine _ (ListElementId r (Id t)) _)
     | M.member t symbols = determineBaseAddressAndOffset registersByAddress requiredAddress
     | otherwise = Nothing
     where registersByAddress = registersFromAddresses table
           requiredAddress = symbols M.! t
mapSymbolToAddress symbols table (LabelledOpCodeLine _ (ListElementId r (Id t)) _ _)
     | M.member t symbols = determineBaseAddressAndOffset registersByAddress requiredAddress
     | otherwise = Nothing
     where registersByAddress = registersFromAddresses table
           requiredAddress = symbols M.! t
mapSymbolToAddress _ _ _ = Nothing