{
module MMix_Parser where

import Data.Char
import MMix_Lexer
}

%name parseFile
%tokentype { Token }
%error { parseError }
%monad { Alex }
%lexer { lexwrap } { LEOF }

%token
    OP_CODE      { TOpCode $$ }
    SET          { TSet }
    COMMA        { TComma }
    HALT         { THalt }
    FPUTS        { TFputS }
    STDOUT       { TStdOut }
    BYTE_LIT     { TByteLiteral $$ }
    ID           { TIdentifier $$ }
    REG          { TRegister $$ }
    INT          { TInteger $$ }
    LOCAL_LABEL  { TLocalLabel $$ }
    FORWARD      { TLocalForwardOperand $$ }
    BACKWARD     { TLocalBackwardOperand $$ }
    LOC          { TLOC }
    IS           { TIS }
    WYDE         { TWyde }
    TETRA        { TTetra }
    OCTA         { TOcta }
    GREG         { TGREG }
    PLUS         { TPlus }
    MINUS        { TMinus }
    MULTIPLY     { TMult }
    DIVIDE       { TDivide }
    AT           { TAtSign }
    DS           { TDataSegment }
    BYTE         { TByte }
    STR          { TStringLiteral $$ }
    HEX          { THexLiteral $$ }
    OPEN         { TOpenParen }
    CLOSE        { TCloseParen }
%%

Program         : AssignmentLines { reverse $1 }

AssignmentLines : {- empty -}        {[]}
                | AssignmentLines AssignmentLine { $2 : $1 }

AssignmentLine :: {Line}
AssingmentLine : OP_CODE Ops { defaultPlainOpCodeLine { pocl_code = $1, pocl_ops = $2 } }
               | Identifier PI { defaultLabelledPILine { lppl_id = $2, lppl_ident = $1 } }
               | Identifier OP_CODE Ops { defaultLabelledOpCodeLine { lpocl_code = $2, lpocl_ops = $3, lpocl_ident = $1 }  }
               | PI { defaultPlainPILine { ppl_id = $1 } }

Ops : OperatorElement { $1 : [] }
    | Ops COMMA OperatorElement { $3 : $1 }

OperatorElement : HALT       { PseudoCode 0 }
                | FPUTS      { fputs }
                | STDOUT     { PseudoCode 1 }
                | REG        { Register $1 }
                | FORWARD    { LocalForward $1 }
                | BACKWARD   { LocalBackward $1 }
                | Expression { Expr $1 }

Identifier : ID { Id $1 }
           | LOCAL_LABEL { LocalLabel $1 }

PI : LOC Expression      { LocEx $2 }
   | GREG Expression     { GregEx $2 }
   | SET OperatorElement COMMA OperatorElement { Set ($2, $4) }
   | BYTE Byte_Array     { ByteArray (reverse $2) }
   | WYDE Byte_Array     { WydeArray (reverse $2) }
   | TETRA Byte_Array    { TetraArray (reverse $2) }
   | OCTA Byte_Array     { OctaArray (reverse $2) }
   | IS INT              { IsNumber $2 }
   | IS REG              { IsRegister $2 }
   | IS Identifier       { IsIdentifier $2 }

Byte_Array : STR { reverse $1 }
           | HEX { (chr $1) : [] }
           | BYTE_LIT { $1 : [] }
           | Byte_Array COMMA STR { (reverse $3) ++ $1 }
           | Byte_Array COMMA BYTE_LIT { $3 : $1 }
           | Byte_Array COMMA HEX { (chr $3) : $1 }

GlobalVariables : DS { 0x20000000 }

Expression : Term { $1 }
           | Expression Weak_Operator Term { $3 ++ [$2] ++ $1 }

Term : Primary_Expression { $1 }
     | Term Strong_Operator Primary_Expression { $3 ++ [$2] ++ $1 }

Primary_Expression : INT                   { (ExpressionNumber $1) : [] }
                   | Identifier            { (ExpressionIdentifier $1) : [] }
                   | BYTE_LIT              { (ExpressionNumber (ord $1)) : [] }
                   | AT                    { ExpressionAT : [] }
                   | HEX                   { (ExpressionNumber $1) : [] }
                   | GlobalVariables       { (ExpressionNumber $1) : [] }
                   | OPEN Expression CLOSE { $2 }

Strong_Operator : MULTIPLY { ExpressionMultiply }
                | DIVIDE   { ExpressionDivide }

Weak_Operator : PLUS   { ExpressionPlus }
              | MINUS  { ExpressionMinus }

{
data Line = PlainOpCodeLine { pocl_code :: Int, pocl_ops :: [OperatorElement], pocl_loc :: Int }
          | LabelledOpCodeLine { lpocl_code :: Int, lpocl_ops :: [OperatorElement], lpocl_ident :: Identifier, lpocl_loc :: Int }
          | PlainPILine { ppl_id :: PseudoInstruction, ppl_loc :: Int }
          | LabelledPILine { lppl_id :: PseudoInstruction, lppl_ident :: Identifier, lppl_loc :: Int }
          deriving (Eq, Show)

data Identifier = Id String
                | LocalLabel Int
                deriving (Eq, Show, Ord)

data OperatorElement = ByteLiteral Char
               | PseudoCode Int
               | Register Int
               | Ident Identifier
               | LocalForward Int
               | LocalBackward Int
               | Expr [ExpressionEntry]
               deriving (Eq, Show)

data ExpressionEntry = ExpressionNumber Int
                        | ExpressionRegister Int
                        | ExpressionIdentifier Identifier
                        | ExpressionGV Int
                        | Expression
                        | ExpressionAT
                        | ExpressionPlus
                        | ExpressionMinus
                        | ExpressionMultiply
                        | ExpressionDivide
                        deriving (Eq, Show)

data PseudoInstruction = LOC Int
                       | LocEx [ExpressionEntry]
                       | GregAuto
                       | GregSpecific Char
                       | GregEx [ExpressionEntry]
                       | ByteArray [Char]
                       | WydeArray [Char]
                       | TetraArray [Char]
                       | OctaArray [Char]
                       | IsRegister Int
                       | IsNumber Int
                       | IsIdentifier Identifier
                       | Set (OperatorElement, OperatorElement)
                       deriving (Eq, Show)

-- fullParse "/home/steveedmans/test.mms"
-- fullParse "/home/steveedmans/hail.mms"

defaultPlainOpCodeLine = PlainOpCodeLine { pocl_loc = -1 }
defaultLabelledOpCodeLine = LabelledOpCodeLine { lpocl_loc = -1 }
defaultPlainPILine = PlainPILine { ppl_loc = -1 }
defaultLabelledPILine = LabelledPILine { lppl_loc = -1 }

parseError m = alexError $ "WHY! " ++ show m

lexwrap :: (Token -> Alex a) -> Alex a
lexwrap cont = do
    token <- alexMonadScan
    cont token

fputs = PseudoCode 7

fullParse path = do
    contents <- readFile path
    print $ parseStr contents

parseStr str = runAlex str parseFile

}