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
    BYTE        { TByteLiteral $$ }
    ID          { TIdentifier $$ }
    REG         { TRegister $$ }
    LOC         { TLOC }
    DS          { TDataSegment }
%%

Program         : AssignmentLines { reverse $1 }

AssignmentLines : {- empty -}        {[]}
                | AssignmentLines AssignmentLine { $2 : $1 }

AssignmentLine :: {Line}
AssingmentLine : OP_CODE OperatorList { PlainOpCodeLine $1 $2 }
               | ID OP_CODE OperatorList { LabelledOpCodeLine $2 $3 $1 }
               | PI { PlainPILine $1 }

OperatorList : OperatorElement COMMA OperatorElement COMMA OperatorElement { ListElements $1 $3 $5 }
             | OperatorElement COMMA Identifier { ListElementId $1 $3 }
             | Identifier COMMA OperatorElement { ListIdElement $1 $3 }

OperatorElement : BYTE { ByteLiteral $1 }
                | HALT { PseudoCode 0 }
                | REG  { Register $1 }

Identifier : ID { Id $1 }

PI : LOC GlobalVariables { LOC $2 }

GlobalVariables : DS { 0x20000000 }

{
data Line = PlainOpCodeLine Int OperatorList
          | LabelledOpCodeLine Int OperatorList String
          | PlainPILine PseudoInstruction
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
                       deriving (Eq, Show)

-- fullParse "/home/steveedmans/test.mms"

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