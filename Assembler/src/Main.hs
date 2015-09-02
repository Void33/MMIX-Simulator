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
import Expressions

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
    let s0 = parseStr x
    let s1 =  setLocalSymbolLabelAuto s0
    let s2 = setAlexLoc s1
    let initial_st = createSymbolTable s2
    let s3 = evaluateAllExpressions s2 initial_st
    let s4 = setAlexLoc s3
    let s5 = setAlexGregAuto s4
    let st = createSymbolTable s5
    let s6 = evaluateAllExpressions s5 st
    let regs = createRegisterTable s6
    let st2 = createSymbolTable s6
    let code = acg st2 regs s6
    print code
    let pg = encodeProgram code regs
    case pg of
        Right encoded_program -> writeFile ofs encoded_program
        Left error            -> print error
    print pg
    return s6

contents' ifs = do
    x <- readFile ifs
    printf "%s\n" x
    let s0 = parseStr x
    let s1 =  setLocalSymbolLabelAuto s0
    let s2 = setAlexLoc s1
    let initial_st = createSymbolTable s2
    let s3 = evaluateAllExpressions s2 initial_st
    let s4 = setAlexLoc s3
    let s5 = setAlexGregAuto s4
    let st = createSymbolTable s5
    let s6 = evaluateAllExpressions s5 st
    let regs = createRegisterTable s6
    let st2 = createSymbolTable s6
    let code = acg st2 regs s6
    --print s6
    --print st2
    --print regs
    --print code
    let pg = encodeProgram code regs
    --case pg of
    --    Right encoded_program -> print encoded_program
    --    Left error            -> print error
    print pg
    return s6

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
                  where newline = CodeLine {cl_address = 0, cl_size = 0, cl_code = (show ln)}


sampleBaseTable :: RegisterTable
sampleBaseTable = M.insert (chr 254) (ExpressionNumber 100) M.empty

sampleSymbolTable :: M.Map Identifier RegisterAddress
sampleSymbolTable = M.insert (Id "txt") (110, Nothing) M.empty

sampleRA :: RegisterAddress
sampleRA = (110, Nothing)

testLine = "j0     GREG  PRIME1+2-@"

gcfl symbols registers (LabelledOpCodeLine opcode operands _ address) = goco symbols registers opcode operands address
gcfl symbols registers (PlainOpCodeLine opcode operands address) = goco symbols registers opcode operands address

t1 = LabelledOpCodeLine {lpocl_code = 34, lpocl_ops = [Register '\255',Expr (ExpressionIdentifier (Id "txt"))], lpocl_ident = Id "Main", lpocl_loc = 256}
t2 = LabelledOpCodeLine {lpocl_code = 134, lpocl_ops = [Expr (ExpressionIdentifier (Id "pk")),Expr (ExpressionIdentifier (Id "ptop")),Expr (ExpressionIdentifier (Id "mm"))], lpocl_ident = Id "??2H2", lpocl_loc = 359}
t3 = PlainOpCodeLine {pocl_code = 0, pocl_ops = [Expr (ExpressionNumber 0),PseudoCode 0,Expr (ExpressionNumber 0)], pocl_loc = 427}

to1 = Expr (ExpressionIdentifier (Id "pk"))
to2 = Expr (ExpressionIdentifier (Id "ptop"))
to3 = Expr (ExpressionIdentifier (Id "mm"))
to4 = Expr (ExpressionNumber 0)
to5 = PseudoCode 0


tst = M.fromList [(Id "Main",(256,Nothing)),(Id "txt",(536870912,Just (ByteArray "Hello world!\n\NUL")))] :: SymbolTable
trt = M.fromList [('\254',ExpressionNumber 536870912),('\255',ExpressionNumber 256)]

tst2 = M.fromList [(Id "??0H0",(363,Just (IsRegister 244))),(Id "??1H0",(371,Nothing)),(Id "??2H0",(256,Nothing)),(Id "??2H1",(335,Nothing)),(Id "??2H2",(359,Nothing)),(Id "??3H0",(264,Nothing)),(Id "??3H1",(347,Nothing)),(Id "??4H0",(268,Nothing)),(Id "??5H0",(272,Just (Set (Expr (ExpressionIdentifier (Id "kk")),Expr (ExpressionIdentifier (Id "j0")))))),(Id "??6H0",(272,Nothing)),(Id "??7H0",(288,Nothing)),(Id "??8H0",(296,Nothing)),(Id "BUF",(536871912,Just (OctaArray "\NUL"))),(Id "Blanks",(331,Just (ByteArray "   \NUL"))),(Id "L",(0,Just (IsNumber 500))),(Id "Main",(256,Just (Set (Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionNumber 3))))),(Id "NewLn",(329,Just (ByteArray "\n\NUL"))),(Id "PRIME1",(536870912,Just (WydeArray "\STX"))),(Id "Title",(304,Just (ByteArray "First Five Hundred Primes"))),(Id "j0",(536871912,Just (IsRegister 246))),(Id "jj",(0,Just (IsRegister 251))),(Id "kk",(0,Just (IsRegister 250))),(Id "mm",(0,Just (IsRegister 248))),(Id "n",(0,Just (IsRegister 254))),(Id "pk",(0,Just (IsRegister 249))),(Id "ptop",(536871912,Just (IsRegister 247))),(Id "q",(0,Just (IsRegister 253))),(Id "r",(0,Just (IsRegister 252))),(Id "t",(0,Just (IsRegister 255)))] :: SymbolTable
trt2 = M.fromList [('\244',ExpressionNumber 2319406791617675264),('\245',ExpressionNumber 304),('\246',ExpressionNumber (-998)),('\247',ExpressionNumber 536871912),('\248',ExpressionNumber 0),('\249',ExpressionNumber 0),('\250',ExpressionNumber 0),('\251',ExpressionNumber 0),('\252',ExpressionNumber 0),('\253',ExpressionNumber 0),('\254',ExpressionNumber 0),('\255',ExpressionNumber 256)]

goco symbols registers opcode operands address =
    case so symbols registers operands of
        Just((adjustment,params)) -> Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + adjustment)) : params})
        _ -> Nothing

so symbols registers ((Register x):(Expr (ExpressionIdentifier y)):[]) =
    case ro of
        Just((base, offset)) -> Just(1, x : base : (chr offset) : [])
        otherwise -> Just(-1, [])
        where ro = mapSymbolToAddress symbols registers y
so symbols registers (x : y : z : []) = Just(0, output)
--    where output = (show x) ++ (show y) ++ (show z)
    where output = (formatElement symbols x) : (formatElement symbols y) : (formatElement symbols z) : []
so _ _ _ = Nothing

fe st (Expr (ExpressionIdentifier id)) =
    case M.lookup id st of
        (Just (_, Just (IsRegister r))) -> chr r
--fe st (Expr x) = chr (evaluate x 0 st)
--fe _ _ = chr 0