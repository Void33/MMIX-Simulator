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
import DataTypes
import Expressions as E
import System.Environment
import Data.List
import System.FilePath
import System.Exit

main :: IO ExitCode
main = do
       args <- getArgs
       case args of
            (source:[]) -> process source
            _           -> displayUsage

process :: [Char] -> IO ExitCode
process sourceFile = do
       let outputFile = replaceExtension sourceFile "se"
       result <- contents sourceFile outputFile
       case result of
           Left _ -> exitFailure
           Right _ -> exitSuccess

displayUsage :: IO ExitCode
displayUsage = do
       putStrLn "usage: MMixAssembler sourceFile"
       exitSuccess

contents ifs ofs = do
    x <- readFile ifs
    let s0 = parseStr x
    let s1 =  setLocalSymbolLabelAuto s0
    let s2 = setAlexLoc s1
    let initial_st = createSymbolTable s2
    let s3 = evaluateAllLocExpressions s2 initial_st
    let s4 = setAlexLoc s3
    let s5 = setAlexGregAuto s4
    let st = createSymbolTable s5
    let s6 = evaluateAllExpressions s5 st
    let regs = createRegisterTable s6
    let st2 = createSymbolTable s6
    let code = acg st2 regs s6
    --print code
    let pg = encodeProgram code regs
    case pg of
        Right encoded_program -> writeFile ofs encoded_program
        Left error            -> putStrLn error
    return pg

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
showLoc (PlainOpCodeLine _ _ loc _) acc =  loc : acc
showLoc (LabelledOpCodeLine _ _ _ loc _) acc =  loc : acc


acg (Right sym) (Right regs) (Right lns) = Right $ cg sym regs [] lns
acg _ _ _ = Left "Something is missing!!!"

--cg :: (M.Map String RegisterAddress) -> (M.Map Char Int) -> [Line] -> [Line]
cg _ _ acc [] = acc
cg s r acc (ln:lns) = cg s r newAcc lns
    where cgl = genCodeForLine s r ln
          newAcc = case cgl of
              Just(codeline) -> codeline : acc
              Nothing -> acc
                  where newline = CodeLine {cl_address = 0, cl_size = 0, cl_code = (show ln)}
