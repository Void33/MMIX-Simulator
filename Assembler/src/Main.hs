module Main where

import MMix_Lexer
import MMix_Parser
import Text.Printf
import qualified Data.Map.Lazy as M
import qualified Data.List.Ordered as O
import Data.Char
import SymbolTable
import CodeGen
import Locations
import Registers

main :: IO()
main = undefined

--contents "/home/steveedmans/development/MMIX-Simulator/Sample/hail1.mms"
--parseOnly "/home/steveedmans/development/MMIX-Simulator/Sample/hail1.mms"
--toks "/home/steveedmans/development/MMIX-Simulator/Sample/hail1.mms"
--contents "/home/steveedmans/development/MMIX-Simulator/Sample/Simple.mms"

toks fs = do
    x <- readFile fs
    printf "%s\n" x
    let s = tokens x
    return s

parseOnly fs = do
    x <- readFile fs
    printf "%s\n" x
    let s = parseStr x
    return s

contents fs = do
    x <- readFile fs
    printf "%s\n" x
    let s = parseStr x
    let s' = setAlexGregAuto $ setAlexLoc s
    let st = createSymbolTable s'
    let regs = createRegisterTable s'
    let code = acg st regs s'
    print st
    print regs
    print code
    return s'

contents' fs = do
    x <- readFile fs
    printf "%s\n" x
    let s = parseStr x
    --let s1 = setAlexGregAuto s
    let s' = setAlexGregAuto $ setAlexLoc s
    return s'

-- contents "/home/steveedmans/hail.mms"
-- parseOnly "/home/steveedmans/hail.mms"
-- contents "/home/steveedmans/test.mms"

setAlexLoc :: Either String [Line] -> Either String [Line]
setAlexLoc (Right lns) = Right $ setLoc 0 lns
setAlexLoc m = m

setLoc :: Int -> [Line] -> [Line]
setLoc startLoc lns = setInnerLocation startLoc [] lns

showAlexLocs :: Either String [Line] -> Either String [Int]
showAlexLocs (Right lns) = Right $ showLocs lns
showAlexLocs (Left msg) = Left msg

showLocs :: [Line] -> [Int]
showLocs lns = foldr showLoc [] lns

showLoc :: Line -> [Int] -> [Int]
showLoc (PlainPILine _ loc) acc =  loc : acc
showLoc (LabelledPILine _ _ loc) acc =  loc : acc
showLoc (PlainOpCodeLine _ _ loc) acc =  loc : acc
showLoc (LabelledOpCodeLine _ _ _ loc) acc =  loc : acc


acg (Right sym) (Right regs) (Right lns) = Right $ cg sym regs [] lns
acg _ _ _ = Left "Something is missing!!!"

--cg :: (M.Map String RegisterAddress) -> (M.Map Char Int) -> [Line] -> [Line]
cg _ _ acc [] = acc
cg s r acc (ln:lns) = cg s r newAcc lns
    where cgl = genCodeForLine s r ln
          newAcc = case cgl of
              Just(a, s, ba) -> (a, s, ba) : acc
              Nothing -> acc

params = [(Register (chr 255)), Ident (Id "txt")]
params2 =  [LocalBackward 2,Ident (Id "t")]
samplePILine = defaultLabelledPILine {lppl_id = (GregEx [ExpressionAT]), lppl_loc=536870912, lppl_ident=(Id "txt")}
samplePILine2 = defaultPlainPILine {ppl_id = (GregEx [ExpressionAT]), ppl_loc=536870912}
samplePILine3 = defaultLabelledPILine {lppl_id = ByteArray "Hello World!", lppl_loc=536870912, lppl_ident=(Id "txt")}
samplePILine4 = defaultPlainPILine {ppl_id = LocEx [ExpressionNumber 536870912], ppl_loc = 0}
samplePILine5 = defaultLabelledPILine {lppl_id = LocEx [ExpressionNumber 536870912], lppl_loc = 0, lppl_ident=(Id "txt")}
samplePILine6 = defaultLabelledPILine {lppl_id = (GregEx [ExpressionNumber 0]), lppl_loc=536870912, lppl_ident=(Id "txt")}
samplePILine7 = defaultPlainPILine {ppl_id = (GregEx [ExpressionNumber 0]), ppl_loc=536870912}
sampleLine = defaultPlainOpCodeLine {pocl_code = 35, pocl_ops = params2, pocl_loc=536870912}
sampleLine2 = defaultLabelledOpCodeLine {lpocl_code = 35, lpocl_ops = params, lpocl_ident = (Id "txt2"), lpocl_loc=536870912}
sampleLine3 = defaultPlainOpCodeLine {pocl_code = 35, pocl_ops = params2, pocl_loc=536870912}
sampleLine4 = defaultLabelledOpCodeLine {lpocl_code = 35, lpocl_ops = params, lpocl_ident = (Id "txt2"), lpocl_loc=536870912}
sampleLine5 = defaultPlainOpCodeLine {pocl_code = 0, pocl_ops = params2, pocl_loc = 259}
sampleMainLine = LabelledOpCodeLine {lpocl_code = 34, lpocl_ops = [Register '\255',Expr [ExpressionIdentifier (Id "txt")]], lpocl_ident = Id "Main", lpocl_loc = 256}

sampleBaseTable :: RegisterTable
sampleBaseTable = M.insert (chr 254) 100 M.empty

sampleSymbolTable :: M.Map Identifier RegisterAddress
sampleSymbolTable = M.insert (Id "txt") (110, Nothing) M.empty

sampleRA :: RegisterAddress
sampleRA = (110, Nothing)

testLine = "j0     GREG  PRIME1+2-@"
