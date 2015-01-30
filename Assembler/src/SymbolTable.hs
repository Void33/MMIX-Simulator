module SymbolTable where

import MMix_Parser
import qualified Data.Map.Lazy as M
import Data.Char (chr)

type Table = M.Map String Int

type RegisterAddress = (Int, Maybe PseudoInstruction)

createSymbolTable :: Either String [Line] -> Either String (M.Map String RegisterAddress)
createSymbolTable (Left msg) = Left msg
createSymbolTable (Right lines) = foldl getSymbol (Right M.empty) lines

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
getRegister (Right table) _ = Right $ table

findRegister :: RegisterAddress -> (M.Map Char Int) -> Int
findRegister (address, Nothing) regs = 0
findRegister _ _ = -1

sr :: M.Map Char Int
sr = M.singleton (chr 255) 256

aa :: RegisterAddress -> (M.Map Char Int) -> Maybe Char
aa (address, Nothing) lst = initial $ M.keys $ M.filter (\ v -> v == address) lst
            where initial [] = Nothing
                  initial (reg:regs) = Just reg
