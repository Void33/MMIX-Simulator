module Main where

import MMix_Lexer
import MMix_Parser
import Text.Printf
import qualified Data.Map.Lazy as M
import Data.Char
import SymbolTable
import CodeGen

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
    --let s1 = setAlexGregAuto s
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
setAlexLoc m@_ = m

setLoc :: Int -> [Line] -> [Line]
setLoc startLoc lns = setInnerLoc startLoc [] lns

setInnerLoc :: Int -> [Line] -> [Line] -> [Line]
setInnerLoc nextLoc acc [] = reverse acc
setInnerLoc nextLoc acc (ln@(PlainPILine (LOC loc) _):lns) = setInnerLoc loc newAcc lns
                                                 where newAcc = ln { ppl_loc = loc } : acc
setInnerLoc nextLoc acc (ln@(LabelledPILine (LOC loc) _ _):lns) = setInnerLoc loc newAcc lns
                                                 where newAcc = ln { ppl_loc = loc } : acc
setInnerLoc nextLoc acc (ln@(LabelledPILine (ByteArray arr) _ _):lns) = setInnerLoc newLoc newAcc lns
                                                 where newLoc = nextLoc + (length arr)
                                                       newAcc = ln { lppl_loc = nextLoc } : acc
setInnerLoc nextLoc acc (ln@(PlainPILine _ _):lns) = setInnerLoc nextLoc newAcc lns
                                                 where newAcc = ln { ppl_loc = nextLoc } : acc
setInnerLoc nextLoc acc (ln@(LabelledPILine _ _ _):lns) = setInnerLoc nextLoc newAcc lns
                                                 where newAcc = ln { lppl_loc = nextLoc } : acc
setInnerLoc nextLoc acc (ln@(PlainOpCodeLine _ _ _):lns) = setInnerLoc newLoc newAcc lns
                                                 where newAcc = ln { pocl_loc = nextLoc } : acc
                                                       newLoc = nextLoc + 4
setInnerLoc nextLoc acc (ln@(LabelledOpCodeLine _ _ _ _):lns) = setInnerLoc newLoc newAcc lns
                                                 where newAcc = ln { lpocl_loc = nextLoc } : acc
                                                       newLoc = nextLoc + 4

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

setAlexGregAuto :: Either String [Line] -> Either String [Line]
setAlexGregAuto (Right lns) = Right $ setGregAuto (chr 254) [] lns
setAlexGregAuto msg = msg

setGregAuto :: Char -> [Line] -> [Line] -> [Line]
setGregAuto _ acc [] = reverse acc
setGregAuto currentRegister acc (x:xs) =
    let (newLine, nextRegister) = specifyGregAuto x currentRegister
        newAcc = newLine : acc
    in setGregAuto nextRegister newAcc xs

specifyGregAuto :: Line -> Char -> (Line, Char)
specifyGregAuto ln@(PlainPILine GregAuto _) nxt = (ln{ppl_id = GregSpecific nxt}, (decrement nxt))
specifyGregAuto ln@(LabelledPILine GregAuto _ _) nxt = (ln{lppl_id = GregSpecific nxt}, (decrement nxt))
specifyGregAuto line nxt = (line, nxt)

decrement :: Char -> Char
decrement val = chr decreased
          where decreased = (ord val) - 1

acg (Right sym) (Right regs) (Right lns) = Right $ cg sym regs [] lns
acg _ _ _ = Left "Something is missing!!!"

--cg :: (M.Map String RegisterAddress) -> (M.Map Char Int) -> [Line] -> [Line]
cg _ _ acc [] = acc
cg s r acc (ln:lns) = cg s r newAcc lns
    where cgl = genCodeForLine s r ln
          newAcc = case cgl of
              Just(a, s, ba) -> (a, s, ba) : acc
              Nothing -> acc

params = ListElementId (Register 255) (Id "txt")
params2 = ListElementId (Register 255) (Id "txt2")
samplePILine = defaultLabelledPILine {lppl_id = GregAuto, lppl_loc=536870912, lppl_ident="txt"}
samplePILine2 = defaultPlainPILine {ppl_id = GregAuto, ppl_loc=536870912}
samplePILine3 = defaultLabelledPILine {lppl_id = ByteArray "Hello World!", lppl_loc=536870912, lppl_ident="txt"}
sampleLine = defaultPlainOpCodeLine {pocl_code = 35, pocl_ops = params, pocl_loc=536870912}
sampleLine2 = defaultLabelledOpCodeLine {lpocl_code = 35, lpocl_ops = params, lpocl_ident = "txt2", lpocl_loc=536870912}
sampleLine3 = defaultPlainOpCodeLine {pocl_code = 35, pocl_ops = params2, pocl_loc=536870912}
sampleLine4 = defaultLabelledOpCodeLine {lpocl_code = 35, lpocl_ops = params2, lpocl_ident = "txt2", lpocl_loc=536870912}
sampleLine5 = defaultPlainOpCodeLine {pocl_code = 0, pocl_ops = ListElements (ByteLiteral '\NUL') (PseudoCode 7) (PseudoCode 1), pocl_loc = 259}

sampleBaseTable :: M.Map Char Int
sampleBaseTable = M.insert (chr 254) 100 M.empty

sampleSymbolTable :: M.Map String RegisterAddress
sampleSymbolTable = M.insert "txt" (110, Nothing) M.empty

sampleRA :: RegisterAddress
sampleRA = (110, Nothing)