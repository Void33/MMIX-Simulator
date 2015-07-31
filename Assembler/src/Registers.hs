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

type RegisterAddress = (Int, Maybe PseudoInstruction)
type RegisterTable = M.Map Char Int
type AlternativeRegisterTable = M.Map Int Char

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
specifyGregAuto ln@(PlainPILine (GregEx lst) loc) nxt =
    case (isSingleExprAT lst, isSingleExprNumber lst) of
        (True, _) -> (ln{ppl_id = GregEx [ExpressionRegister (chr nxt), ExpressionNumber loc]}, nxt - 1)
        (False, Just (val)) -> (ln{ppl_id = GregEx [ExpressionRegister (chr nxt), ExpressionNumber val]}, nxt - 1)
        _ -> (ln, nxt)
specifyGregAuto ln@(LabelledPILine (GregEx lst) _ loc) nxt =
    case (isSingleExprAT lst, isSingleExprNumber lst) of
        (True, _) -> (ln{lppl_id = GregEx [ExpressionRegister (chr nxt), ExpressionNumber loc]}, nxt - 1)
        (False, Just (val)) -> (ln{lppl_id = GregEx [ExpressionRegister (chr nxt), ExpressionNumber val]}, nxt - 1)
        _ -> (ln, nxt)
specifyGregAuto line nxt = (line, nxt)


createRegisterTable :: Either String [Line] -> Either String RegisterTable
createRegisterTable (Left msg) = Left msg
createRegisterTable (Right lines) = foldl getRegister (Right M.empty) lines

getRegister :: Either String RegisterTable -> Line -> Either String RegisterTable
getRegister (Left msg) _ = Left msg
getRegister (Right table) (LabelledOpCodeLine _ _ (Id "Main") address)
        | M.member (chr 255) table = Left $ "Duplicate Main section definition"
        | otherwise = Right $ M.insert (chr 255) address table
getRegister (Right table) (PlainPILine pi@(GregEx details) address) = addRegister table r n
        where r = firstRegister details
              n = firstNumber details
getRegister (Right table) (LabelledPILine pi@(GregEx details) _ address) = addRegister table r n
        where r = firstRegister details
              n = firstNumber details
getRegister (Right table) _ = Right $ table

addRegister table (Just register) (Just address)
    | M.member register table = Left $ "Duplicate register definition " ++ (show register)
    | otherwise = Right $ M.insert register address table
addRegister _ _ _ = Left "Incorrect Details Found"

registersFromAddresses :: RegisterTable -> AlternativeRegisterTable
registersFromAddresses orig = M.foldrWithKey addNextRegister M.empty orig

addNextRegister :: Char -> Int -> AlternativeRegisterTable -> AlternativeRegisterTable
addNextRegister k v orig = M.insert v k orig

getRegisterDetails :: [ExpressionEntry] -> Maybe(Char, Int)
getRegisterDetails _ = Nothing

firstRegister :: [ExpressionEntry] -> Maybe(Char)
firstRegister [] = Nothing
firstRegister ((ExpressionRegister reg): _) = Just(reg)
fristRegister (_:rest) = firstRegister rest

firstNumber :: [ExpressionEntry] -> Maybe(Int)
firstNumber [] = Nothing
firstNumber ((ExpressionNumber val): _) = Just(val)
firstNumber (_:rest) = firstNumber rest
