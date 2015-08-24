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

contents ifs ofs = do
    x <- readFile ifs
    printf "%s\n" x
    let s = parseStr x
    let s' = setAlexGregAuto $ setAlexLoc s
    let st = createSymbolTable s'
    let regs = createRegisterTable s'
    let code = acg st regs s'
    --print st
    --print regs
    --print code
    let pg = encodeProgram code regs
    case pg of
        Right encoded_program -> writeFile ofs encoded_program
        Left error            -> print error
    print pg
    return s'

contents' ifs = do
    x <- readFile ifs
    printf "%s\n" x
    let s = parseStr x
    let s' = setAlexGregAuto $ setAlexLoc s
    let s2 = setLocalSymbolLabelAuto s'
    let st = createSymbolTable s'
    let regs = createRegisterTable s'
    let code = acg st regs s'
    print s2
    --print regs
    --print code
    --let pg = encodeProgram code regs
    --case pg of
    --    Right encoded_program -> print encoded_program
    --    Left error            -> print error
    --print pg
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
              Just(codeline) -> codeline : acc
              Nothing -> acc

params = [(Register (chr 255)), Ident (Id "txt")]
params2 =  [LocalBackward 2,Ident (Id "t")]
samplePILine = defaultLabelledPILine {lppl_id = (GregEx ExpressionAT), lppl_loc=536870912, lppl_ident=(Id "txt")}
samplePILine2 = defaultPlainPILine {ppl_id = (GregEx ExpressionAT), ppl_loc=536870912}
samplePILine3 = defaultLabelledPILine {lppl_id = ByteArray "Hello World!", lppl_loc=536870912, lppl_ident=(Id "txt")}
samplePILine4 = defaultPlainPILine {ppl_id = LocEx (ExpressionNumber 536870912), ppl_loc = 0}
samplePILine5 = defaultLabelledPILine {lppl_id = LocEx (ExpressionNumber 536870912), lppl_loc = 0, lppl_ident=(Id "txt")}
samplePILine6 = defaultLabelledPILine {lppl_id = (GregEx (ExpressionNumber 0)), lppl_loc=536870912, lppl_ident=(Id "txt")}
samplePILine7 = defaultPlainPILine {ppl_id = (GregEx (ExpressionNumber 0)), ppl_loc=536870912}
sampleLine = defaultPlainOpCodeLine {pocl_code = 35, pocl_ops = params2, pocl_loc=536870912}
sampleLine2 = defaultLabelledOpCodeLine {lpocl_code = 35, lpocl_ops = params, lpocl_ident = (Id "txt2"), lpocl_loc=536870912}
sampleLine3 = defaultPlainOpCodeLine {pocl_code = 35, pocl_ops = params2, pocl_loc=536870912}
sampleLine4 = defaultLabelledOpCodeLine {lpocl_code = 35, lpocl_ops = params, lpocl_ident = (Id "txt2"), lpocl_loc=536870912}
sampleLine5 = defaultPlainOpCodeLine {pocl_code = 0, pocl_ops = params2, pocl_loc = 259}
sampleMainLine = LabelledOpCodeLine {lpocl_code = 34, lpocl_ops = [Register '\255',Expr (ExpressionIdentifier (Id "txt"))], lpocl_ident = Id "Main", lpocl_loc = 256}
sampleTrapLine = PlainOpCodeLine {pocl_code = 0, pocl_ops = [Expr (ExpressionNumber 0),PseudoCode 0,Expr (ExpressionNumber 0)], pocl_loc = 264}
sampleProgram = [CodeLine {cl_address = 256, cl_size = 4, cl_code = "#\255\254\NUL"},CodeLine {cl_address = 260, cl_size = 4, cl_code = "\NUL\NUL\a\NUL"},CodeLine {cl_address = 264, cl_size = 4, cl_code = "\NUL\NUL\NUL\NUL"},CodeLine {cl_address = 536870912, cl_size = 14, cl_code = "Hello world!\n\NUL"}]
sampleLocalSymbolLabelLine = LabelledOpCodeLine {lpocl_code = 166, lpocl_ops = [Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionIdentifier (Id "ptop")),Expr (ExpressionIdentifier (Id "jj"))], lpocl_ident = LocalLabel 2, lpocl_loc = 0}
s1 = LabelledOpCodeLine {lpocl_code = 66, lpocl_ops = [Expr (ExpressionIdentifier (Id "jj")),LocalForward 2], lpocl_ident = Id "??3H0", lpocl_loc = 264}
ops = [Expr (ExpressionIdentifier (Id "jj")),LocalForward 2]
prog =  [LabelledPILine {lppl_id = IsNumber 500, lppl_ident = Id "L", lppl_loc = 0},LabelledOpCodeLine {lpocl_code = 166, lpocl_ops = [Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionIdentifier (Id "ptop")),Expr (ExpressionIdentifier (Id "jj"))], lpocl_ident = LocalLabel 2, lpocl_loc = 0},PlainOpCodeLine {pocl_code = 231, pocl_ops = [Expr (ExpressionIdentifier (Id "jj")),Expr (ExpressionNumber 2)], pocl_loc = 4},LabelledOpCodeLine {lpocl_code = 66, lpocl_ops = [Expr (ExpressionIdentifier (Id "jj")),LocalForward 2], lpocl_ident = LocalLabel 3, lpocl_loc = 8},PlainOpCodeLine {pocl_code = 76, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),LocalBackward 2], pocl_loc = 12},LabelledOpCodeLine {lpocl_code = 34, lpocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "Title"))], lpocl_ident = LocalLabel 2, lpocl_loc = 16}]
p1 = [LabelledPILine {lppl_id = IsNumber 500, lppl_ident = Id "L", lppl_loc = 0},LabelledOpCodeLine {lpocl_code = 166, lpocl_ops = [Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionIdentifier (Id "ptop")),Expr (ExpressionIdentifier (Id "jj"))], lpocl_ident = Id "??2H0", lpocl_loc = 0},PlainOpCodeLine {pocl_code = 231, pocl_ops = [Expr (ExpressionIdentifier (Id "jj")),Expr (ExpressionNumber 2)], pocl_loc = 4},LabelledOpCodeLine {lpocl_code = 66, lpocl_ops = [Expr (ExpressionIdentifier (Id "jj")),LocalForward 2], lpocl_ident = Id "??3H0", lpocl_loc = 8},PlainOpCodeLine {pocl_code = 76, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),LocalBackward 2], pocl_loc = 12},LabelledOpCodeLine {lpocl_code = 34, lpocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "Title"))], lpocl_ident = Id "??2H1", lpocl_loc = 16}]

sampleOperands = [Register '\255',Expr (ExpressionIdentifier (Id "txt"))]
sampleBaseTable :: RegisterTable
sampleBaseTable = M.insert (chr 254) 100 M.empty

sampleSymbolTable :: M.Map Identifier RegisterAddress
sampleSymbolTable = M.insert (Id "txt") (110, Nothing) M.empty

sampleRA :: RegisterAddress
sampleRA = (110, Nothing)

testLine = "j0     GREG  PRIME1+2-@"
