{
import Data.Char
import MMix_Lexer
}

%name parseFile
%tokentype { Token }
%error { parseError }
%monad { Alex }
%lexer { lexwrap } { LEOF }

%token
    OP_CODE     { TOpCode $$ }
    COMMA       { TComma }
    HALT        { THalt }
    FPUTS       { TFputS }
    STDOUT      { TStdOut }
    BYTE_LIT    { TByteLiteral $$ }
    ID          { TIdentifier $$ }
    REG         { TRegister $$ }
    LOC         { TLOC }
    GREG        { TGREG }
    AT          { TAtSign }
    DS          { TDataSegment }
    BYTE        { TByte }
    STR         { TStringLiteral $$ }
    HEX         { THexLiteral $$ }
%%

Program         : AssignmentLines { reverse $1 }

AssignmentLines : {- empty -}        {[]}
                | AssignmentLines AssignmentLine { $2 : $1 }

AssignmentLine :: {Line}
AssingmentLine : OP_CODE TwoPartOperatorList { PlainOpCodeLine ($1 + 1) $2 }
               | OP_CODE ThreePartOperatorList { PlainOpCodeLine $1 $2 }
               | ID OP_CODE TwoPartOperatorList { LabelledOpCodeLine ($2 + 1) $3 $1 }
               | ID OP_CODE ThreePartOperatorList { LabelledOpCodeLine $2 $3 $1 }
               | PI { PlainPILine $1 }
               | ID PI { LabelledPILine $2 $1 }

ThreePartOperatorList : OperatorElement COMMA OperatorElement COMMA OperatorElement { ListElements $1 $3 $5 }

TwoPartOperatorList   : OperatorElement COMMA Identifier { ListElementId $1 $3 }

OperatorElement : BYTE_LIT { ByteLiteral $1 }
                | HALT     { PseudoCode 0 }
                | FPUTS    { PseudoCode 7 }
                | STDOUT   { PseudoCode 1 }
                | REG      { Register $1 }

Identifier : ID { Id $1 }

PI : LOC GlobalVariables { LOC $2 }
   | LOC HEX             { LOC $2 }
   | GREG AT             { GregAuto }
   | BYTE Byte_Array     { ByteArray (reverse $2) }

Byte_Array : STR { reverse $1 }
           | Byte_Array COMMA STR { (reverse $3) ++ $1 }
           | Byte_Array COMMA BYTE_LIT { $3 : $1 }

GlobalVariables : DS { 0x20000000 }

{
data Line = PlainOpCodeLine Int OperatorList
          | LabelledOpCodeLine Int OperatorList String
          | PlainPILine PseudoInstruction
          | LabelledPILine PseudoInstruction String
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
               deriving (Eq, Show)

data PseudoInstruction = LOC Int
                       | GregAuto
                       | GregSpecific Int
                       | ByteArray [Char]
                       deriving (Eq, Show)

-- fullParse "/home/steveedmans/test.mms"
-- fullParse "/home/steveedmans/hail.mms"

parseError m = alexError $ "WHY! " ++ show m

lexwrap :: (Token -> Alex a) -> Alex a
lexwrap cont = do
    token <- alexMonadScan
    cont token

fullParse path = do
    contents <- readFile path
    print $ parseStr contents

parseStr str = runAlex str parseFile

}