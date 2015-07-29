{
module MMix_Lexer where

import Data.Char (chr)
import Numeric (readDec)
import Numeric (readHex)

import Debug.Trace
}

%wrapper "monadUserState"

$digit    = 0-9            -- digits
$alpha    = [a-zA-Z]       -- alphabetic characters
$hexdigit = [0-9a-eA-E]    -- hexadecimal digits

tokens :-

<0>$white+		  	                    ;
<0>[Ii][Ss]                             { mkT TIS }
<0>[Gg][Rr][Ee][Gg]                     { mkT TGREG }
<0>[Ll][Oo][Cc]                         { mkT TLOC }
<0>[Bb][Yy][Tt][Ee]                     { mkT TByte }
<0>[Ww][Yy][Dd][Ee]                     { mkT TWyde }
<0>[Tt][Ee][Tt][Rr][Aa]                 { mkT TTetra }
<0>[Oo][Cc][Tt][Aa]                     { mkT TOcta }
<0>[Ss][Ee][Tt]                         { mkT TSet }
<0>Data_Segment                         { mkT TDataSegment }
<0>\@                                   { mkT TAtSign }
<0>\+                                   { mkT TPlus }
<0>\-                                   { mkT TMinus }
<0>\*                                   { mkT TMult }
<0>\\                                   { mkT TDivide }
<0>\#$hexdigit+                         { mkHex }
<0>\$$digit+                            { mkRegister }
<0>[Tt][Rr][Aa][Pp]                     { mkT $ TOpCode 0x00 }
<0>[Ff][Cc][Mm][Pp]                     { mkT $ TOpCode 0x01 }
<0>[Ff][Uu][Nn]                         { mkT $ TOpCode 0x02 }
<0>[Ff][Ee][Qq][Ll]                     { mkT $ TOpCode 0x03 }
<0>[Ff][Aa][Dd][Dd]                     { mkT $ TOpCode 0x04 }
<0>[Ff][Ii][Xx]                         { mkT $ TOpCode 0x05 }
<0>[Ff][Ss][Uu][Bb]                     { mkT $ TOpCode 0x06 }
<0>[Ff][Ii][Xx][Uu]                     { mkT $ TOpCode 0x07 }
<0>[Ff][Ll][Oo][Tt]                     { mkT $ TOpCode 0x08 }
<0>[Ff][Ll][Oo][Tt][Uu]                 { mkT $ TOpCode 0x0A }
<0>[Ss][Ff][Ll][Oo][Tt]                 { mkT $ TOpCode 0x0C }
<0>[Ss][Ff][Ll][Oo][Tt][Uu]             { mkT $ TOpCode 0x0E }
<0>[Ff][Mm][Uu][Ll]                     { mkT $ TOpCode 0x10 }
<0>[Ff][Cc][Mm][Pp][Ee]                 { mkT $ TOpCode 0x11 }
<0>[Ff][Uu][Nn][Ee]                     { mkT $ TOpCode 0x12 }
<0>[Ff][Ee][Qq][Ll][Ee]                 { mkT $ TOpCode 0x13 }
<0>[Ff][Dd][Ii][Vv]                     { mkT $ TOpCode 0x14 }
<0>[Ff][Ss][Qq][Rr][Tt]                 { mkT $ TOpCode 0x15 }
<0>[Ff][Rr][Ee][Mm]                     { mkT $ TOpCode 0x16 }
<0>[Ff][Ii][Nn][Tt]                     { mkT $ TOpCode 0x17 }
<0>[Mm][Uu][Ll]                         { mkT $ TOpCode 0x18 }
<0>[Mm][Uu][Ll][Uu]                     { mkT $ TOpCode 0x1A }
<0>[Dd][Ii][Vv]                         { mkT $ TOpCode 0x1C }
<0>[Dd][Ii][Vv][Uu]                     { mkT $ TOpCode 0x1E }
<0>[Aa][Dd][Dd]                         { mkT $ TOpCode 0x20 }
<0>[Ll][Dd][Aa]                         { mkT $ TOpCode 0x22 }
<0>[Ss][Tt][Bb]                         { mkT $ TOpCode 0xA0 }
<0>Fputs                                { mkT TFputS }
<0>StdOut                               { mkT TStdOut }
<0>Halt                                 { mkT THalt }
<0>$digit+	                            { mkInteger }
<0>\,                                   { mkT TComma }
<0>\"                                   { startString `andBegin` string }
<string>\\\"                            { addCharToString '\"' }
<string>\\\\                            { addCharToString '\\' }
<string>\"                              { endString `andBegin` state_initial }
<string>.                               { addCurrentToString }
<0>$alpha [$alpha $digit \_ \']*        { mkIdentifier }
<0>.                                    { mkError }

{
data Token = LEOF
            | TIdentifier { tid_name :: String }
            | TError { terr_text :: String }
            | TInteger { tint_value :: Int }
            | THexLiteral { thex_value :: Int }
            | TRegister { treg_value :: Int }
            | TStringLiteral { tsl_text :: String }
            | TIS
            | TByte
            | TGREG
            | TLOC
            | TWyde
            | TTetra
            | TOcta
            | TSet
            | TFputS
            | TStdOut
            | THalt
            | TOpCode { toc_value :: Int }
            | TDataSegment
            | TAtSign
            | TComma
            | TPlus
            | TMult
            | TMinus
            | TDivide
            | TByteLiteral Char
            | W String
            | CommentStart
            | CommentEnd
            | CommentBody String
            deriving (Show,Eq)

state_initial :: Int
state_initial = 0

data AlexUserState = AlexUserState
                   {
                     lexerStringState    :: Bool
                     , lexerStringValue  :: String
                   }

alexInitUserState :: AlexUserState
alexInitUserState = AlexUserState
                   {
                     lexerStringState    = False
                     , lexerStringValue  = ""
                   }

setLexerStringState :: Bool -> Alex ()
setLexerStringState ss = Alex $ \s -> Right (s{alex_ust=(alex_ust s){lexerStringState=ss}}, ())

setLexerStringValue :: String -> Alex ()
setLexerStringValue ss = Alex $ \s -> Right (s{alex_ust=(alex_ust s){lexerStringValue=ss}}, ())

getLexerStringValue :: Alex String
getLexerStringValue = Alex $ \s@AlexState{alex_ust=ust} -> Right (s, lexerStringValue ust)

addCharToLexerStringValue :: Char -> Alex ()
addCharToLexerStringValue c = Alex $ \s -> Right (s{alex_ust=(alex_ust s){lexerStringValue=c:lexerStringValue (alex_ust s)}}, ())

addCurrentToString :: (t, t1, t2, String) -> Int -> Alex Token
addCurrentToString input@(_, _, _, remaining) length =
    addCharToString c input length
    where
        c = if (length == 1)
            then head remaining
            else error "Invalid call to addCurrentString"

addCharToString :: Char -> t -> t1 -> Alex Token
addCharToString c _     _   =
    do
        addCharToLexerStringValue c
        alexMonadScan

word a@(_,c,_,inp) len = mkT (W (take len inp)) a len

extractValue :: Num a => [(a, String)] -> a
extractValue ((value, ""):_) = value
extractValue _ = error "Invalid Hex Value"

mkHex :: Monad m => (t, t1, t2, String) -> Int -> m Token
mkHex input length =
    mkT (THexLiteral decValue) input length
    where
        str = getStr input length
        hexPart = tail str
        decValue = extractValue $ readHex hexPart

mkInteger input length
    | val >= 0 && val < 256 = mkT (TByteLiteral (chr val)) input length
    | otherwise = mkT (TInteger val) input length
    where val = read (getStr input length) :: Int

mkRegister input length
    | val >=0 && val < 256 = mkT (TRegister val) input length
    | otherwise = mkT (TError ("Invalid Register " ++ registerText)) input length
    where
        registerText = getStr input length
        val = read (tail registerText) :: Int

mkIdentifier :: Monad m => (t, t1, t2, String) -> Int -> m Token
mkIdentifier input length =
    mkT (TIdentifier label) input length
    where label = getStr input length

mkError :: Monad m => (t, t1, t2, String) -> Int -> m Token
mkError input length =
    mkT (TError label) input length
    where label = getStr input length

getStr (_, _, _, remaining) length = take length remaining

mkT :: (Monad m) => Token -> t -> t1 -> m Token
mkT token _ _ = return $ token

alexEOF = return LEOF

startString _ _ =
    do
        setLexerStringValue ""
        setLexerStringState True
        alexMonadScan

endString input length =
    do
        s <- getLexerStringValue
        setLexerStringState False
        mkT (TStringLiteral (reverse s)) input length

tokens str = runAlex str $ do
               let loop = do tok <- alexMonadScan
                             if tok == LEOF
                               then return [ LEOF ]
                               else do toks <- loop
                                       return $ tok : toks
               loop
}
