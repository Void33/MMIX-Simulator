module Registers
--(
--    RegisterAddress,
--    RegisterTable,
--    createRegisterTable
--)
where

import MMix_Parser
import qualified Data.Map.Lazy as M
import Data.Char (chr, ord)
import Expressions
import DataTypes

type RegisterTable = M.Map Char ExpressionEntry
type AlternativeRegisterTable = M.Map ExpressionEntry Char

setAlexGregAuto :: Either String [Line] -> Either String [Line]
setAlexGregAuto (Right lns) = Right $ setGregAuto 254 [] lns
setAlexGregAuto msg = msg

setGregAuto :: Int -> [Line] -> [Line] -> [Line]
setGregAuto _ acc [] = reverse acc
setGregAuto currentRegister acc (x:xs) =
    let (newLine, nextRegister) = specifyGregAuto x currentRegister
        newAcc = newLine : acc
    in setGregAuto nextRegister newAcc xs

specifyGregAuto :: Line -> Int -> (Line, Int)
specifyGregAuto ln@(LabelledPILine (GregEx val) _ loc) nxt = (new_line, new_counter)
   where new_line = ln{lppl_id = GregEx (ExpressionRegister (chr nxt) val)}
         new_counter = nxt - 1
specifyGregAuto ln@(PlainPILine (GregEx val) loc) nxt =  (new_line, new_counter)
   where new_line = ln{ppl_id = GregEx (ExpressionRegister (chr nxt) val)}
         new_counter = nxt - 1
specifyGregAuto line nxt = (line, nxt)


createRegisterTable :: Either String [Line] -> Either String RegisterTable
createRegisterTable (Left msg) = Left msg
createRegisterTable (Right lines) = foldl getRegister (Right M.empty) lines

getRegister :: Either String RegisterTable -> Line -> Either String RegisterTable
getRegister (Left msg) _ = Left msg
getRegister (Right table) (LabelledOpCodeLine _ _ (Id "Main") address _)
        | M.member (chr 255) table = Left $ "Duplicate Main section definition"
        | otherwise = Right $ M.insert (chr 255) (ExpressionNumber address) table
getRegister (Right table) (LabelledPILine _ (Id "Main") address)
        | M.member (chr 255) table = Left $ "Duplicate Main section definition"
        | otherwise = Right $ M.insert (chr 255) (ExpressionNumber address) table
getRegister (Right table) (PlainPILine pi@(GregEx (ExpressionRegister r ExpressionAT)) address) =
        addRegister table r (ExpressionNumber address)
getRegister (Right table) (LabelledPILine pi@(GregEx (ExpressionRegister r ExpressionAT)) _ address) =
        addRegister table r (ExpressionNumber address)
getRegister (Right table) (LabelledPILine pi@(GregEx (ExpressionRegister r (ExpressionNumber v))) _ address) =
        addRegister table r (ExpressionNumber v)
getRegister (Right table) _ = Right $ table

addRegister table register address
    | M.member register table = Left $ "Duplicate register definition " ++ (show register)
    | otherwise = Right $ M.insert register address table

registersFromAddresses :: RegisterTable -> AlternativeRegisterTable
registersFromAddresses orig = M.foldrWithKey addNextRegister M.empty without_main
   where without_main = M.filterWithKey remove_main orig

remove_main :: Char -> ExpressionEntry -> Bool
remove_main k _
  | k == (chr 255) = False
  | otherwise      = True

addNextRegister :: Char -> ExpressionEntry -> AlternativeRegisterTable -> AlternativeRegisterTable
addNextRegister k v orig = M.insert v k orig

getRegisterDetails :: [ExpressionEntry] -> Maybe(Char, Int)
getRegisterDetails _ = Nothing
