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
    let s3 = evaluateAllLocExpressions s2 initial_st
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
    let st0 = createSymbolTable s0
    let s1 =  setLocalSymbolLabelAuto s0
    let st1 = createSymbolTable s1
    let s2 = setAlexLoc s1
    let initial_st = createSymbolTable s2
    let s3 = evaluateAllLocExpressions s2 initial_st
    let s4 = setAlexLoc s3
    let s5 = setAlexGregAuto s4
    let st = createSymbolTable s5
    let s6 = evaluateAllExpressions s5 st
    let regs = createRegisterTable s6
    let st2 = createSymbolTable s6
    --print "ST0"
    --print st0
    --print "ST1"
    --print st1
    --print "INITIAL ST"
    --print initial_st
    print "ST"
    print st
    print "ST2"
    print st2
    print regs
    let code = acg st2 regs s6
    print code
    let pg = encodeProgram code regs
    case pg of
        Right encoded_program -> print encoded_program
        Left error            -> print error
    --print s0
    --print s1
    --print s2
    --print s3
    --print s4
    --print s5
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


sampleBaseTable :: RegisterTable
sampleBaseTable = M.insert (chr 254) (ExpressionNumber 100) M.empty

sampleSymbolTable :: M.Map Identifier RegisterAddress
sampleSymbolTable = M.insert (Id "txt") (110, Nothing) M.empty

sampleRA :: RegisterAddress
sampleRA = (110, Nothing)

testLine = "j0     GREG  PRIME1+2-@"

gcfl symbols registers (LabelledOpCodeLine opcode operands _ address _) = goco symbols registers opcode operands address
--gcfl symbols registers (PlainOpCodeLine 254 operands address _) = Just (0, (sro symbols operands))
gcfl symbols registers (PlainOpCodeLine opcode operands address _) = goco symbols registers opcode operands address
--gcfl _ _ (PlainPILine (ByteArray arr) address) = Just(CodeLine {cl_address = address, cl_size = s, cl_code = arr})
--    where s = length arr
--gcfl symbols registers (LabelledPILine (Set (e1, e2)) _ address) =
--    gpico symbols registers address e1 e2
--gcfl _ _ ln = Nothing

gpico :: SymbolTable -> RegisterTable -> Int -> OperatorElement -> OperatorElement -> Maybe(CodeLine)
--gpico symbols registers address i1@(Expr (ExpressionIdentifier _)) i2@(Expr (ExpressionIdentifier _)) = goco symbols registers 193 operands address
--    where operands = i1 : i2 : (Expr (ExpressionNumber 0)) : []
--gpico symbols registers address i1@(Expr (ExpressionIdentifier _)) i2@(Expr (ExpressionNumber _)) = goco symbols registers 227 operands address
--    where operands = i1 : i2 : (Expr (ExpressionNumber 0)) : []
--gpico symbols registers address r1@(Register _) r2@(Register _) = genOpCodeOutput symbols registers 192 operands address
--    where operands = r1 : r2 : (Expr (ExpressionNumber 0)) : []
--gpico symbols registers address r1@(Register _) r2@(Expr (ExpressionNumber _)) = genOpCodeOutput symbols registers 227 operands address
--    where operands = r1 : r2 : []
gpico _ _ _ _ _ = Nothing

t36 = LabelledOpCodeLine {lpocl_code = 34, lpocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "Title"))], lpocl_ident = Id "??2H1", lpocl_loc = 348, lpocl_sim = False}
t44 = PlainOpCodeLine {pocl_code = 174, pocl_ops = [Ident (Id "??0H0"),Expr (ExpressionIdentifier (Id "BUF"))], pocl_loc = 376, pocl_sim = False}
t45 = PlainOpCodeLine {pocl_code = 34, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionNumber 536871916)], pocl_loc = 380, pocl_sim = False}
t46 = LabelledOpCodeLine {lpocl_code = 28, lpocl_ops = [Expr (ExpressionIdentifier (Id "pk")),Expr (ExpressionIdentifier (Id "pk")),Expr (ExpressionNumber 10)], lpocl_ident = Id "??1H0", lpocl_loc = 384, lpocl_sim = False}
t49 = PlainOpCodeLine {pocl_code = 162, pocl_ops = [Expr (ExpressionIdentifier (Id "r")),Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionNumber 0)], pocl_loc = 396, pocl_sim = False}
t50 = PlainOpCodeLine {pocl_code = 36, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionNumber 1)], pocl_loc = 400, pocl_sim = False}
t51 = PlainOpCodeLine {pocl_code = 90, pocl_ops = [Expr (ExpressionIdentifier (Id "pk")),Ident (Id "??1H0")], pocl_loc = 404, pocl_sim = False}
t55 = PlainOpCodeLine {pocl_code = 80, pocl_ops = [Expr (ExpressionIdentifier (Id "mm")),Ident (Id "??2H2")], pocl_loc = 420, pocl_sim = False}
t58 = PlainOpCodeLine {pocl_code = 48, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "mm")),Expr (ExpressionNumber 98)], pocl_loc = 432, pocl_sim = False}
t59 = PlainOpCodeLine {pocl_code = 90, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Ident (Id "??3H1")], pocl_loc = 436, pocl_sim = False}

tst = M.fromList [(Id "Main",(256,Nothing)),(Id "txt",(536870912,Just (ByteArray "Hello world!\n\NUL")))] :: SymbolTable
trt = M.fromList [('\254',ExpressionNumber 536870912),('\255',ExpressionNumber 256)]
etrt = Right trt :: Either String RegisterTable

i1 = Id "??2H1"

tst1 = M.fromList [(Id "??0H0",(376,Just (IsRegister 245))),(Id "??1H0",(384,Nothing)),(Id "??2H0",(264,Nothing)),(Id "??2H1",(348,Nothing)),(Id "??2H2",(372,Nothing)),(Id "??3H0",(272,Nothing)),(Id "??3H1",(360,Nothing)),(Id "??4H0",(276,Nothing)),(Id "??5H0",(280,Just (Set (Expr (ExpressionIdentifier (Id "kk")),Expr (ExpressionIdentifier (Id "j0")))))),(Id "??6H0",(284,Nothing)),(Id "??7H0",(300,Nothing)),(Id "??8H0",(308,Nothing)),(Id "BUF",(536871912,Just (OctaArray "\NUL"))),(Id "Blanks",(343,Just (ByteArray "   \NUL"))),(Id "L",(0,Just (IsNumber 500))),(Id "Main",(256,Just (Set (Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionNumber 3))))),(Id "NewLn",(341,Just (ByteArray "\n\NUL"))),(Id "PRIME1",(536870912,Just (WydeArray "\STX"))),(Id "Title",(316,Just (ByteArray "First Five Hundred Primes"))),(Id "j0",(536871912,Just (IsRegister 247))),(Id "jj",(0,Just (IsRegister 251))),(Id "kk",(0,Just (IsRegister 250))),(Id "mm",(0,Just (IsIdentifier (Id "kk")))),(Id "n",(0,Just (IsRegister 254))),(Id "pk",(0,Just (IsRegister 249))),(Id "ptop",(536871912,Just (IsRegister 248))),(Id "q",(0,Just (IsRegister 253))),(Id "r",(0,Just (IsRegister 252))),(Id "t",(0,Just (IsRegister 255)))] :: SymbolTable
tst2 = M.fromList [(Id "??0H0",(375,Just (IsRegister 245))),(Id "??1H0",(383,Nothing)),(Id "??2H0",(264,Nothing)),(Id "??2H1",(347,Nothing)),(Id "??2H2",(371,Nothing)),(Id "??3H0",(272,Nothing)),(Id "??3H1",(359,Nothing)),(Id "??4H0",(276,Nothing)),(Id "??5H0",(280,Just (Set (Expr (ExpressionIdentifier (Id "kk")),Expr (ExpressionIdentifier (Id "j0")))))),(Id "??6H0",(284,Nothing)),(Id "??7H0",(300,Nothing)),(Id "??8H0",(308,Nothing)),(Id "BUF",(536871912,Just (OctaArray "\NUL"))),(Id "Blanks",(343,Just (ByteArray "   \NUL"))),(Id "L",(0,Just (IsNumber 500))),(Id "Main",(256,Just (Set (Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionNumber 3))))),(Id "NewLn",(341,Just (ByteArray "\n\NUL"))),(Id "PRIME1",(536870912,Just (WydeArray "\STX"))),(Id "Title",(316,Just (ByteArray "First Five Hundred Primes"))),(Id "j0",(536871912,Just (IsRegister 247))),(Id "jj",(0,Just (IsRegister 251))),(Id "kk",(0,Just (IsRegister 250))),(Id "mm",(0,Just (IsIdentifier (Id "kk")))),(Id "n",(0,Just (IsRegister 254))),(Id "pk",(0,Just (IsRegister 249))),(Id "ptop",(536871912,Just (IsRegister 248))),(Id "q",(0,Just (IsRegister 253))),(Id "r",(0,Just (IsRegister 252))),(Id "t",(0,Just (IsRegister 255)))] :: SymbolTable
trt2 = M.fromList [('\245',ExpressionNumber 2319406791617675264),('\246',ExpressionNumber 316),('\247',ExpressionNumber (-998)),('\248',ExpressionNumber 536871912),('\249',ExpressionNumber 0),('\250',ExpressionNumber 0),('\251',ExpressionNumber 0),('\252',ExpressionNumber 0),('\253',ExpressionNumber 0),('\254',ExpressionNumber 0),('\255',ExpressionNumber 256)]
etrt2 = Right trt2 :: Either String RegisterTable
trt2S = registersFromAddresses trt2

r1 = ('\246',ExpressionNumber (-998))
r1a = fst r1
r1b = snd r1

e45 = ExpressionPlus (ExpressionIdentifier (Id "BUF")) (ExpressionNumber 4)

o36 = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "Title"))]
o44 = [Ident (Id "??0H0"),Expr (ExpressionIdentifier (Id "BUF"))]
o45 = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionNumber 536871916)]
o46 = [Expr (ExpressionIdentifier (Id "pk")),Expr (ExpressionIdentifier (Id "pk")),Expr (ExpressionNumber 10)]

sproc = [LabelledPILine {lppl_id = IsNumber 500, lppl_ident = Id "L", lppl_loc = 0},LabelledPILine {lppl_id = IsRegister 255, lppl_ident = Id "t", lppl_loc = 0},LabelledPILine {lppl_id = GregEx (ExpressionNumber 0), lppl_ident = Id "n", lppl_loc = 0},LabelledPILine {lppl_id = GregEx (ExpressionNumber 0), lppl_ident = Id "q", lppl_loc = 0},LabelledPILine {lppl_id = GregEx (ExpressionNumber 0), lppl_ident = Id "r", lppl_loc = 0},LabelledPILine {lppl_id = GregEx (ExpressionNumber 0), lppl_ident = Id "jj", lppl_loc = 0},LabelledPILine {lppl_id = GregEx (ExpressionNumber 0), lppl_ident = Id "kk", lppl_loc = 0},LabelledPILine {lppl_id = GregEx (ExpressionNumber 0), lppl_ident = Id "pk", lppl_loc = 0},LabelledPILine {lppl_id = IsIdentifier (Id "kk"), lppl_ident = Id "mm", lppl_loc = 0},PlainPILine {ppl_id = LocEx (ExpressionNumber 536870912), ppl_loc = 536870912},LabelledPILine {lppl_id = WydeArray "\STX", lppl_ident = Id "PRIME1", lppl_loc = 536870912},PlainPILine {ppl_id = LocEx (ExpressionPlus (ExpressionIdentifier (Id "PRIME1")) (ExpressionMultiply (ExpressionNumber 2) (ExpressionIdentifier (Id "L")))), ppl_loc = -1},LabelledPILine {lppl_id = GregEx ExpressionAT, lppl_ident = Id "ptop", lppl_loc = 536870914},LabelledPILine {lppl_id = GregEx (ExpressionMinus (ExpressionPlus (ExpressionIdentifier (Id "PRIME1")) (ExpressionNumber 2)) ExpressionAT), lppl_ident = Id "j0", lppl_loc = 536870914},LabelledPILine {lppl_id = OctaArray "\NUL", lppl_ident = Id "BUF", lppl_loc = 536870920},PlainPILine {ppl_id = LocEx (ExpressionNumber 256), ppl_loc = 256},LabelledPILine {lppl_id = Set (Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionNumber 3)), lppl_ident = Id "Main", lppl_loc = 256},PlainPILine {ppl_id = Set (Expr (ExpressionIdentifier (Id "jj")),Expr (ExpressionIdentifier (Id "j0"))), ppl_loc = 260},LabelledOpCodeLine {lpocl_code = 166, lpocl_ops = [Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionIdentifier (Id "ptop")),Expr (ExpressionIdentifier (Id "jj"))], lpocl_ident = Id "??2H0", lpocl_loc = 264, lpocl_sim = False},PlainOpCodeLine {pocl_code = 231, pocl_ops = [Expr (ExpressionIdentifier (Id "jj")),Expr (ExpressionNumber 2)], pocl_loc = 268, pocl_sim = True},LabelledOpCodeLine {lpocl_code = 66, lpocl_ops = [Expr (ExpressionIdentifier (Id "jj")),Ident (Id "??2H1")], lpocl_ident = Id "??3H0", lpocl_loc = 272, lpocl_sim = False},LabelledOpCodeLine {lpocl_code = 231, lpocl_ops = [Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionNumber 2)], lpocl_ident = Id "??4H0", lpocl_loc = 276, lpocl_sim = True},LabelledPILine {lppl_id = Set (Expr (ExpressionIdentifier (Id "kk")),Expr (ExpressionIdentifier (Id "j0"))), lppl_ident = Id "??5H0", lppl_loc = 280},LabelledOpCodeLine {lpocl_code = 134, lpocl_ops = [Expr (ExpressionIdentifier (Id "pk")),Expr (ExpressionIdentifier (Id "ptop")),Expr (ExpressionIdentifier (Id "kk"))], lpocl_ident = Id "??6H0", lpocl_loc = 284, lpocl_sim = False},PlainOpCodeLine {pocl_code = 28, pocl_ops = [Expr (ExpressionIdentifier (Id "q")),Expr (ExpressionIdentifier (Id "n")),Expr (ExpressionIdentifier (Id "pk"))], pocl_loc = 288, pocl_sim = False},PlainOpCodeLine {pocl_code = 254, pocl_ops = [Expr (ExpressionIdentifier (Id "r")),Expr (ExpressionIdentifier (Id "rR"))], pocl_loc = 292, pocl_sim = True},PlainOpCodeLine {pocl_code = 66, pocl_ops = [Expr (ExpressionIdentifier (Id "r")),Ident (Id "??4H0")], pocl_loc = 296, pocl_sim = False},LabelledOpCodeLine {lpocl_code = 48, lpocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "q")),Expr (ExpressionIdentifier (Id "pk"))], lpocl_ident = Id "??7H0", lpocl_loc = 300, lpocl_sim = False},PlainOpCodeLine {pocl_code = 76, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Ident (Id "??2H0")], pocl_loc = 304, pocl_sim = False},LabelledOpCodeLine {lpocl_code = 231, lpocl_ops = [Expr (ExpressionIdentifier (Id "kk")),Expr (ExpressionNumber 2)], lpocl_ident = Id "??8H0", lpocl_loc = 308, lpocl_sim = True},PlainOpCodeLine {pocl_code = 240, pocl_ops = [Ident (Id "??6H0")], pocl_loc = 312, pocl_sim = False},PlainPILine {ppl_id = GregEx ExpressionAT, ppl_loc = 316},LabelledPILine {lppl_id = ByteArray "First Five Hundred Primes", lppl_ident = Id "Title", lppl_loc = 316},LabelledPILine {lppl_id = ByteArray "\n\NUL", lppl_ident = Id "NewLn", lppl_loc = 341},LabelledPILine {lppl_id = ByteArray "   \NUL", lppl_ident = Id "Blanks", lppl_loc = 343},LabelledOpCodeLine {lpocl_code = 34, lpocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "Title"))], lpocl_ident = Id "??2H1", lpocl_loc = 348, lpocl_sim = False},PlainOpCodeLine {pocl_code = 0, pocl_ops = [Expr (ExpressionNumber 0),PseudoCode 7,PseudoCode 1], pocl_loc = 352, pocl_sim = True},PlainOpCodeLine {pocl_code = 52, pocl_ops = [Expr (ExpressionIdentifier (Id "mm")),Expr (ExpressionNumber 2)], pocl_loc = 356, pocl_sim = False},LabelledOpCodeLine {lpocl_code = 32, lpocl_ops = [Expr (ExpressionIdentifier (Id "mm")),Expr (ExpressionIdentifier (Id "mm")),Expr (ExpressionIdentifier (Id "j0"))], lpocl_ident = Id "??3H1", lpocl_loc = 360, lpocl_sim = False},PlainOpCodeLine {pocl_code = 34, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "Blanks"))], pocl_loc = 364, pocl_sim = False},PlainOpCodeLine {pocl_code = 0, pocl_ops = [Expr (ExpressionNumber 0),PseudoCode 7,PseudoCode 1], pocl_loc = 368, pocl_sim = True},LabelledOpCodeLine {lpocl_code = 134, lpocl_ops = [Expr (ExpressionIdentifier (Id "pk")),Expr (ExpressionIdentifier (Id "ptop")),Expr (ExpressionIdentifier (Id "mm"))], lpocl_ident = Id "??2H2", lpocl_loc = 372, lpocl_sim = False},LabelledPILine {lppl_id = GregEx (ExpressionNumber 2319406791617675264), lppl_ident = Id "??0H0", lppl_loc = 376},PlainOpCodeLine {pocl_code = 174, pocl_ops = [Ident (Id "??0H0"),Expr (ExpressionIdentifier (Id "BUF"))], pocl_loc = 376, pocl_sim = False},PlainOpCodeLine {pocl_code = 34, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionPlus (ExpressionIdentifier (Id "BUF")) (ExpressionNumber 4))], pocl_loc = 380, pocl_sim = False},LabelledOpCodeLine {lpocl_code = 28, lpocl_ops = [Expr (ExpressionIdentifier (Id "pk")),Expr (ExpressionIdentifier (Id "pk")),Expr (ExpressionNumber 10)], lpocl_ident = Id "??1H0", lpocl_loc = 384, lpocl_sim = False},PlainOpCodeLine {pocl_code = 254, pocl_ops = [Expr (ExpressionIdentifier (Id "r")),Expr (ExpressionIdentifier (Id "rR"))], pocl_loc = 388, pocl_sim = True},PlainOpCodeLine {pocl_code = 231, pocl_ops = [Expr (ExpressionIdentifier (Id "r")),Expr (ExpressionNumber 48)], pocl_loc = 392, pocl_sim = True},PlainOpCodeLine {pocl_code = 162, pocl_ops = [Expr (ExpressionIdentifier (Id "r")),Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionNumber 0)], pocl_loc = 396, pocl_sim = False},PlainOpCodeLine {pocl_code = 36, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionNumber 1)], pocl_loc = 400, pocl_sim = False},PlainOpCodeLine {pocl_code = 90, pocl_ops = [Expr (ExpressionIdentifier (Id "pk")),Ident (Id "??1H0")], pocl_loc = 404, pocl_sim = False},PlainOpCodeLine {pocl_code = 34, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "BUF"))], pocl_loc = 408, pocl_sim = False},PlainOpCodeLine {pocl_code = 0, pocl_ops = [Expr (ExpressionNumber 0),PseudoCode 7,PseudoCode 1], pocl_loc = 412, pocl_sim = True},PlainOpCodeLine {pocl_code = 231, pocl_ops = [Expr (ExpressionIdentifier (Id "mm")),Expr (ExpressionDivide (ExpressionMultiply (ExpressionNumber 2) (ExpressionIdentifier (Id "L"))) (ExpressionNumber 10))], pocl_loc = 416, pocl_sim = True},PlainOpCodeLine {pocl_code = 80, pocl_ops = [Expr (ExpressionIdentifier (Id "mm")),Ident (Id "??2H2")], pocl_loc = 420, pocl_sim = False},PlainOpCodeLine {pocl_code = 34, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "NewLn"))], pocl_loc = 424, pocl_sim = False},PlainOpCodeLine {pocl_code = 0, pocl_ops = [Expr (ExpressionNumber 0),PseudoCode 7,PseudoCode 1], pocl_loc = 428, pocl_sim = True},PlainOpCodeLine {pocl_code = 48, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Expr (ExpressionIdentifier (Id "mm")),Expr (ExpressionMultiply (ExpressionNumber 2) (ExpressionMinus (ExpressionDivide (ExpressionIdentifier (Id "L")) (ExpressionNumber 10)) (ExpressionNumber 1)))], pocl_loc = 432, pocl_sim = False},PlainOpCodeLine {pocl_code = 90, pocl_ops = [Expr (ExpressionIdentifier (Id "t")),Ident (Id "??3H1")], pocl_loc = 436, pocl_sim = False},PlainOpCodeLine {pocl_code = 0, pocl_ops = [Expr (ExpressionNumber 0),PseudoCode 0,Expr (ExpressionNumber 0)], pocl_loc = 440, pocl_sim = True}]

goco symbols registers 254 operands address _ = Just(CodeLine {cl_address = address, cl_size = 4, cl_code = code})
    where code = splitSpecialRegisters symbols operands
goco symbols registers opcode operands address False
    | opcode >= 60 && opcode <= 95 = Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + local_adjustment)) : code})
    | opcode == 240 = Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + jump_adjustment)) : jump_code})
    | opcode == 34 = case soa symbols registers operands of
                        Just(address_adjustment, address_code) -> Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + address_adjustment)) : address_code})
                        _ -> Nothing
    | otherwise = case so symbols registers operands of
        Just((adjustment,params)) -> Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr (opcode + adjustment)) : params})
        _ -> Nothing
      where (local_adjustment, code) = splitLocalOperands symbols operands address
            (jump_adjustment, jump_code) = jumpOperands symbols operands address
            Just(address_adjustment, address_code) = soa symbols registers operands
goco symbols registers opcode operands address True =
    case splitOperands symbols registers operands of
        Just((adjustment,params)) -> Just(CodeLine {cl_address = address, cl_size = 4, cl_code = (chr opcode) : params})
        _ -> Nothing

--slo :: SymbolTable -> [OperatorElement] -> String
slo symbols registers (x:(Ident id):[]) address = (adjustment, code)
    where ro = getSymbolAddress symbols id
          formatted_x = formatElement symbols x
          (adjustment, offset) = localLabelOffset address ro
          b1 = chr (quot offset 256)
          b2 = chr (rem  offset 256)
          code = formatted_x : b1 : b2 : []

sro :: SymbolTable -> [OperatorElement] -> String
sro st (x:(Expr (ExpressionIdentifier (Id special))):[]) = (chr 254) : reg : special_register_to_operand special
    where reg = formatElement st x

--    | M.member identifier symbols = requiredAddress
--    | otherwise = Just('b', 2)
--      where registersByAddress  = registersFromAddresses registers
--            requiredAddress = symbols M.! identifier

--so symbols registers ((Ident id):[]) = Just(1, code)
--    where ro = mapSymbolToAddress symbols registers id
--          code = case ro of
--                     Just((base,offset)) -> (chr 0) : base : (chr offset) : []
so symbols registers ((Ident id1):(Expr (ExpressionIdentifier id2)):[]) = Just(4, code)
    where ro1 = msta symbols registers id1
          ro2 = msta symbols registers id2
          code = case (ro1, ro2) of
                     (Just((base1,_)), Just((base2,offset2))) -> base1 : base2 : (chr offset2) : []
                     otherwise -> []
so symbols registers (x:(Expr (ExpressionNumber y)):[]) = Just(2, code)
    where ops = map chr $ drop 2 $ char4 y
          formatted_x = fe symbols x
          code = formatted_x : ops
--so symbols registers (x:(Ident id):[]) = Just(3, code)
--    where ro = mapSymbolToAddress symbols registers id
--          formatted_x = formatElement symbols x
--          code = case ro of
--                     Just((base,offset)) -> formatted_x : base : (chr offset) : []
--                     otherwise -> []
so symbols registers (x : y : z@(Expr (ExpressionNumber _)) : []) = Just(1, output)
--    where output = (show x) ++ (show y) ++ (show z)
    where output = (formatElement symbols x) : (formatElement symbols y) : (formatElement symbols z) : []
so symbols registers (x : y : z : []) = Just(0, output)
--    where output = (show x) ++ (show y) ++ (show z)
    where output = (formatElement symbols x) : (formatElement symbols y) : (formatElement symbols z) : []
so _ _ _ = Nothing

soa symbols registers (x:(Expr (ExpressionNumber y)):[]) = Just(1, code)
    where registersByAddress = registersFromAddresses registers
          Just(reg, offset) = determineBaseAddressAndOffset registersByAddress (y, Nothing)
          formatted_x = formatElement symbols x
          code = formatted_x : reg : (chr offset) : []
soa symbols registers (x:Expr (ExpressionIdentifier y):[]) =
    case mapSymbolToAddress symbols registers y of
       Just(y_reg, y_offset) -> Just(0, code)
          where formatted_x = formatElement symbols x
                code = formatted_x : y_reg : (chr y_offset) : []
       otherwise -> Nothing
soa _ _ _ = Nothing

msta :: SymbolTable -> RegisterTable -> Identifier -> Maybe(RegisterOffset)
msta symbols registers identifier@(Id _) = result
--    | M.member identifier symbols = determineBaseAddressAndOffset registersByAddress requiredAddress
--    | otherwise = Just('b', 2)
      where registersByAddress = registersFromAddresses registers
            requiredAddress = symbols M.! identifier
            exactRegister   = er requiredAddress
            result          = case exactRegister of
                                 Just(reg) -> Just(reg, 0)
                                 _         -> determineBaseAddressAndOffset registersByAddress requiredAddress
--msta _ _ _ = Nothing

er (_, Just(IsRegister reg)) = Just(chr reg)
er _ = Nothing

fe :: SymbolTable -> OperatorElement -> Char
fe _ (ByteLiteral b) = b
fe _ (PseudoCode pc) = chr pc
fe _ (Register r) = r
fe st (Expr x@(ExpressionIdentifier id)) =
    case M.lookup id st of
        (Just (_, Just (IsRegister r))) -> chr r
        (Just (_, Just (IsIdentifier r))) -> fe st (Expr (ExpressionIdentifier r))
        otherwise -> chr (E.evaluate x 0 st)
fe st (Expr x) = chr (E.evaluate x 0 st)

c8t acc val
    | (val == -1) && ((length acc) == 8) = acc
    | (val < 0) = case (divMod val 256) of
                     (m, r) -> c8t (r : acc) m
    | (val == 0) && ((length acc) == 8) = acc
    | (val == 0) = c8t (0 : acc) val
    | otherwise = case (divMod val 256) of
        (m, r) -> c8t (r : acc) m

eall _ [] acc = reverse acc
eall st (ln:lns) acc = eall st lns (new_line : acc)
        where new_line = ell st ln

ell st ln@(LabelledPILine (LocEx expr) _ address) = ln{lppl_id = (LocEx (ExpressionNumber v))}
   where v = evaluate expr address st
ell st ln@(PlainPILine (LocEx expr) address) = ln{ppl_id = (LocEx (ExpressionNumber v))}
   where v = evaluate expr address st
ell _ ln = ln
