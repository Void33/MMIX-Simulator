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
%%

Program         : AssignmentLines { reverse $1 }

AssignmentLines : {- empty -}        {[]}
                | AssignmentLines AssignmentLine { $2 : $1 }

AssignmentLine :: {Line}
AssingmentLine : OP_CODE TwoPartOperatorList { defaultPlainOpCodeLine { pocl_code = ($1 + 1), pocl_ops = $2 } }
               | OP_CODE ThreePartOperatorList { defaultPlainOpCodeLine { pocl_code = $1, pocl_ops = $2 } }
               | ID PI { defaultLabelledPILine { lppl_id = $2, lppl_ident = $1 } }
               | ID OP_CODE TwoPartOperatorList { defaultLabelledOpCodeLine { lpocl_code = ($2 + 1), lpocl_ops = $3, lpocl_ident = $1} }
               | ID OP_CODE ThreePartOperatorList { defaultLabelledOpCodeLine { lpocl_code = $2, lpocl_ops = $3, lpocl_ident = $1}  }
               | PI { defaultPlainPILine { ppl_id = $1 } }

ThreePartOperatorList : OperatorElement COMMA OperatorElement COMMA OperatorElement { ListElements $1 $3 $5 }

TwoPartOperatorList   : OperatorElement COMMA Identifier { ListElementId $1 $3 }

OperatorElement : BYTE_LIT { ByteLiteral $1 }
                | HALT     { PseudoCode 0 }
                | FPUTS    { fputs }
                | STDOUT   { PseudoCode 1 }
                | REG      { Register $1 }
                | Identifier { Ident $1 }

Identifier : ID { Id $1 }

PI : LOC GlobalVariables { LOC $2 }
   | LOC HEX             { LOC $2 }
   | LOC Loc_Exp         { LocEx $2 }
   | GREG AT             { GregAuto }
   | GREG BYTE_LIT       { GregSpecific $2 }
   | GREG Loc_Exp        { GregEx $2 }
   | SET OperatorElement COMMA OperatorElement { Set ($2, $4) }
   | BYTE Byte_Array     { ByteArray (reverse $2) }
   | WYDE Byte_Array     { WydeArray (reverse $2) }
   | WYDE BYTE_LIT       { WydeArray [$2] }
   | TETRA Byte_Array    { TetraArray (reverse $2) }
   | TETRA BYTE_LIT      { TetraArray [$2] }
   | OCTA Byte_Array     { OctaArray (reverse $2) }
   | OCTA BYTE_LIT       { OctaArray [$2] }
   | IS INT              { IsNumber $2 }
   | IS REG              { IsRegister $2 }
   | IS Identifier       { IsIdentifier $2 }

Byte_Array : STR { reverse $1 }
           | Byte_Array COMMA STR { (reverse $3) ++ $1 }
           | Byte_Array COMMA BYTE_LIT { $3 : $1 }

GlobalVariables : DS { 0x20000000 }

Loc_Exp : Identifier { (ExpressionIdentifier $1) : [] }
        | BYTE_LIT   { (ExpressionNumber $ digitToInt $1) : [] }
        | AT { ExpressionAT : [] }
        | Loc_Exp PLUS BYTE_LIT { (ExpressionNumber (digitToInt $3)) : ExpressionPlus : $1 }
        | Loc_Exp PLUS Identifier { (ExpressionIdentifier $3) : ExpressionPlus : $1 }
        | Loc_Exp PLUS AT { ExpressionAT : ExpressionPlus : $1 }
        | Loc_Exp MINUS BYTE_LIT { (ExpressionNumber (digitToInt $3)) : ExpressionMinus : $1 }
        | Loc_Exp MINUS Identifier { (ExpressionIdentifier $3) : ExpressionMinus : $1 }
        | Loc_Exp MINUS AT { ExpressionAT : ExpressionMinus : $1 }
        | Loc_Exp MULTIPLY BYTE_LIT { (ExpressionNumber (digitToInt $3)) : ExpressionMultiply : $1 }
        | Loc_Exp MULTIPLY Identifier { (ExpressionIdentifier $3) : ExpressionMultiply : $1 }
        | Loc_Exp MULTIPLY AT { ExpressionAT : ExpressionMultiply : $1 }
        | Loc_Exp DIVIDE BYTE_LIT { (ExpressionNumber (digitToInt $3)) : ExpressionDivide : $1 }
        | Loc_Exp DIVIDE Identifier { (ExpressionIdentifier $3) : ExpressionDivide : $1 }
        | Loc_Exp DIVIDE AT { ExpressionAT : ExpressionDivide : $1 }

Expression : Term { $1 }
           | Term Weak_Operator Term { $3 ++ [$2] ++ $1 }

Term : Primary_Expression { $1 : [] }
     | Term Strong_Operator Primary_Expression { $3 : $2 : $1 }

Primary_Expression : INT        { ExpressionNumber $1 }
                   | Identifier { ExpressionIdentifier $1 }
                   | BYTE_LIT   { ExpressionNumber $ digitToInt $1 }
                   | AT         { ExpressionAT }

Strong_Operator : MULTIPLY { ExpressionMultiply }
                | DIVIDE   { ExpressionDivide }

Weak_Operator : PLUS   { ExpressionPlus }
              | MINUS  { ExpressionMinus }

{
data Line = PlainOpCodeLine { pocl_code :: Int, pocl_ops :: OperatorList, pocl_loc :: Int }
          | LabelledOpCodeLine { lpocl_code :: Int, lpocl_ops :: OperatorList, lpocl_ident :: String, lpocl_loc :: Int }
          | PlainPILine { ppl_id :: PseudoInstruction, ppl_loc :: Int }
          | LabelledPILine { lppl_id :: PseudoInstruction, lppl_ident :: String, lppl_loc :: Int }
          deriving (Eq, Show)

data OperatorList = ListElements OpElement OpElement OpElement
                  | ListElementId OpElement Identifier
                  | ListIdElement Identifier OpElement
                  deriving (Eq, Show)

data Identifier = Id String
                deriving (Eq, Show)

data OpElement = ByteLiteral Char
               | PseudoCode Int
               | Register Int
               | Ident Identifier
               deriving (Eq, Show)

data LocExpressionEntry = ExpressionNumber Int
                        | ExpressionRegister Int
                        | ExpressionIdentifier Identifier
                        | ExpressionGV Int
                        | ExpressionAT
                        | ExpressionPlus
                        | ExpressionMinus
                        | ExpressionMultiply
                        | ExpressionDivide
                        deriving (Eq, Show)

data PseudoInstruction = LOC Int
                       | LocEx [LocExpressionEntry]
                       | GregAuto
                       | GregSpecific Char
                       | GregEx [LocExpressionEntry]
                       | ByteArray [Char]
                       | WydeArray [Char]
                       | TetraArray [Char]
                       | OctaArray [Char]
                       | IsRegister Int
                       | IsNumber Int
                       | IsIdentifier Identifier
                       | Set (OpElement, OpElement)
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