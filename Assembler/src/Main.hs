module Main where

import MMix_Lexer
import MMix_Parser
import Text.Printf

main :: IO()
main = undefined

--contents "/home/steveedmans/development/MMIX-Simulator/Sample/hail1.mms"
--contents "/home/steveedmans/development/MMIX-Simulator/Sample/Simple.mms"

contents fs = do
    x <- readFile fs
    printf "%s\n" x
    let s = parseStr x
    let s' = setAlexLoc s
    print $ showAlexLocs s'
    return s'

-- contents "/home/steveedmans/hail.mms"

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
                                                       newLoc = nextLoc + 3
setInnerLoc nextLoc acc (ln@(LabelledOpCodeLine _ _ _ _):lns) = setInnerLoc newLoc newAcc lns
                                                 where newAcc = ln { lpocl_loc = nextLoc } : acc
                                                       newLoc = nextLoc + 3

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

