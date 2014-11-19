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
AssingmentLine : OP_CODE TwoPartOperatorList { defaultPlainOpCodeLine { pocl_code = ($1 + 1), pocl_ops = $2 } }
               | OP_CODE ThreePartOperatorList { defaultPlainOpCodeLine { pocl_code = $1, pocl_ops = $2 } }
               | ID OP_CODE TwoPartOperatorList { defaultLabelledOpCodeLine { lpocl_code = ($2 + 1), lpocl_ops = $3, lpocl_ident = $1} }
               | ID OP_CODE ThreePartOperatorList { defaultLabelledOpCodeLine { lpocl_code = $2, lpocl_ops = $3, lpocl_ident = $1}  }
               | PI { defaultPlainPILine { ppl_id = $1 } }
               | ID PI { defaultLabelledPILine { lppl_id = $2, lppl_ident = $1 } }

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
               deriving (Eq, Show)

data PseudoInstruction = LOC Int
                       | GregAuto
                       | GregSpecific Int
                       | ByteArray [Char]
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

fullParse path = do
    contents <- readFile path
    print $ parseStr contents

parseStr str = runAlex str parseFile

}