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
    OP_CODE        { TOpCode $$ }
    OP_CODE_SIMPLE { TOpCodeSimple $$ }
    SET            { TSet }
    COMMA          { TComma }
    HALT           { THalt }
    FPUTS          { TFputS }
    STDOUT         { TStdOut }
    BYTE_LIT       { TByteLiteral $$ }
    ID             { TIdentifier $$ }
    REG            { TRegister $$ }
    INT            { TInteger $$ }
    LOCAL_LABEL    { TLocalLabel $$ }
    FORWARD        { TLocalForwardOperand $$ }
    BACKWARD       { TLocalBackwardOperand $$ }
    LOC            { TLOC }
    IS             { TIS }
    WYDE           { TWyde }
    TETRA          { TTetra }
    OCTA           { TOcta }
    GREG           { TGREG }
    PLUS           { TPlus }
    MINUS          { TMinus }
    MULTIPLY       { TMult }
    DIVIDE         { TDivide }
    AT             { TAtSign }
    TS             { TTextSegment }
    DS             { TDataSegment }
    PS             { TPoolSegment }
    SS             { TStackSegment }
    BYTE           { TByte }
    STR            { TStringLiteral $$ }
    HEX            { THexLiteral $$ }
    OPEN           { TOpenParen }
    CLOSE          { TCloseParen }
%%

Program         : AssignmentLines { reverse $1 }

AssignmentLines : {- empty -}        {[]}
                | AssignmentLines AssignmentLine { $2 : $1 }

AssignmentLine :: {Line}
AssingmentLine : OP_CODE OperatorList { defaultPlainOpCodeLine { pocl_code = $1, pocl_ops = (reverse $2) } }
               | Identifier PI { defaultLabelledPILine { lppl_id = $2, lppl_ident = $1 } }
               | Identifier OP_CODE OperatorList { defaultLabelledOpCodeLine { lpocl_code = $2, lpocl_ops = (reverse $3), lpocl_ident = $1 }  }
               | PI { defaultPlainPILine { ppl_id = $1 } }
               | OP_CODE_SIMPLE OperatorList { defaultPlainOpCodeLine { pocl_code = $1, pocl_ops = (reverse $2), pocl_sim = True } }
               | Identifier OP_CODE_SIMPLE OperatorList { defaultLabelledOpCodeLine { lpocl_code = $2, lpocl_ops = (reverse $3), lpocl_ident = $1, lpocl_sim = True }  }

OperatorList : OperatorElement { $1 : [] }
    | OperatorList COMMA OperatorElement { $3 : $1 }

OperatorElement : HALT       { PseudoCode 0 }
                | FPUTS      { fputs }
                | STDOUT     { PseudoCode 1 }
                | REG        { Register (chr $1) }
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
   | IS BYTE_LIT         { IsNumber (ord $2) }
   | IS REG              { IsRegister $2 }
   | IS Identifier       { IsIdentifier $2 }

Byte_Array : STR { reverse $1 }
           | HEX { (chr $1) : [] }
           | BYTE_LIT { $1 : [] }
           | Byte_Array COMMA STR { (reverse $3) ++ $1 }
           | Byte_Array COMMA BYTE_LIT { $3 : $1 }
           | Byte_Array COMMA HEX { (chr $3) : $1 }

GlobalVariables : TS { 0x0000000000000000 }
                | DS { 0x2000000000000000 }
                | PS { 0x4000000000000000 }
                | SS { 0x6000000000000000 }

Expression : Term { $1 }
           | Expression PLUS Term { ExpressionPlus $1 $3 }
           | Expression MINUS Term { ExpressionMinus $1 $3 }

Term : Primary_Expression { $1 }
     | Term MULTIPLY Primary_Expression { ExpressionMultiply $1 $3 }
     | Term DIVIDE Primary_Expression { ExpressionDivide $1 $3 }

Primary_Expression : INT                   { ExpressionNumber $1 }
                   | Identifier            { ExpressionIdentifier $1 }
                   | BYTE_LIT              { ExpressionNumber (ord $1) }
                   | AT                    { ExpressionAT }
                   | HEX                   { ExpressionNumber $1 }
                   | GlobalVariables       { ExpressionNumber $1 }
                   | OPEN Expression CLOSE { $2 }


{
data Line = PlainOpCodeLine { pocl_code :: Int, pocl_ops :: [OperatorElement], pocl_loc :: Int, pocl_sim :: Bool }
          | LabelledOpCodeLine { lpocl_code :: Int, lpocl_ops :: [OperatorElement], lpocl_ident :: Identifier, lpocl_loc :: Int, lpocl_sim :: Bool }
          | PlainPILine { ppl_id :: PseudoInstruction, ppl_loc :: Int }
          | LabelledPILine { lppl_id :: PseudoInstruction, lppl_ident :: Identifier, lppl_loc :: Int }
          deriving (Eq, Show)

data Identifier = Id String
                | LocalLabel Int
                deriving (Eq, Show, Ord)

data OperatorElement = ByteLiteral Char
               | PseudoCode Int
               | Register Char
               | Ident Identifier
               | LocalForward Int
               | LocalBackward Int
               | Expr ExpressionEntry
               deriving (Eq, Show)

data ExpressionEntry = ExpressionNumber Int
                        | ExpressionRegister Char ExpressionEntry
                        | ExpressionIdentifier Identifier
                        | ExpressionGV Int
                        | Expression
                        | ExpressionAT
                        | ExpressionPlus ExpressionEntry ExpressionEntry
                        | ExpressionMinus ExpressionEntry ExpressionEntry
                        | ExpressionMultiply ExpressionEntry ExpressionEntry
                        | ExpressionDivide ExpressionEntry ExpressionEntry
                        | ExpressionOpen
                        | ExpressionClose
                        deriving (Eq, Show)

data PseudoInstruction = LOC Int
                       | LocEx ExpressionEntry
                       | GregAuto
                       | GregSpecific Char
                       | GregEx ExpressionEntry
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

defaultPlainOpCodeLine = PlainOpCodeLine { pocl_loc = -1, pocl_sim = False }
defaultLabelledOpCodeLine = LabelledOpCodeLine { lpocl_loc = -1, lpocl_sim = False }
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