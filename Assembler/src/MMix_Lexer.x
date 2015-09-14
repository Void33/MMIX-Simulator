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
<0>($digit)H                            { mkLocalLabel }
<0>($digit)F                            { mkLocalForwardOperand }
<0>($digit)B                            { mkLocalBackwardOperand }
<0>Data_Segment                         { mkT TDataSegment }
<0>\@                                   { mkT TAtSign }
<0>\+                                   { mkT TPlus }
<0>\-                                   { mkT TMinus }
<0>\*                                   { mkT TMult }
<0>\/                                   { mkT TDivide }
<0>\(                                   { mkT TOpenParen }
<0>\)                                   { mkT TCloseParen }
<0>\#$hexdigit+                         { mkHex }
<0>\$$digit+                            { mkRegister }
<0>[Tt][Rr][Aa][Pp]                     { mkT $ TOpCodeSimple 0x00 }
<0>[Ff][Cc][Mm][Pp]                     { mkT $ TOpCodeSimple 0x01 }
<0>[Ff][Uu][Nn]                         { mkT $ TOpCodeSimple 0x02 }
<0>[Ff][Ee][Qq][Ll]                     { mkT $ TOpCodeSimple 0x03 }
<0>[Ff][Aa][Dd][Dd]                     { mkT $ TOpCodeSimple 0x04 }
<0>[Ff][Ii][Xx]                         { mkT $ TOpCodeSimple 0x05 }
<0>[Ff][Ss][Uu][Bb]                     { mkT $ TOpCodeSimple 0x06 }
<0>[Ff][Ii][Xx][Uu]                     { mkT $ TOpCodeSimple 0x07 }
<0>[Ff][Ll][Oo][Tt]                     { mkT $ TOpCode 0x08 }
<0>[Ff][Ll][Oo][Tt][Uu]                 { mkT $ TOpCode 0x0A }
<0>[Ss][Ff][Ll][Oo][Tt]                 { mkT $ TOpCode 0x0C }
<0>[Ss][Ff][Ll][Oo][Tt][Uu]             { mkT $ TOpCode 0x0E }
<0>[Ff][Mm][Uu][Ll]                     { mkT $ TOpCodeSimple 0x10 }
<0>[Ff][Cc][Mm][Pp][Ee]                 { mkT $ TOpCodeSimple 0x11 }
<0>[Ff][Uu][Nn][Ee]                     { mkT $ TOpCodeSimple 0x12 }
<0>[Ff][Ee][Qq][Ll][Ee]                 { mkT $ TOpCodeSimple 0x13 }
<0>[Ff][Dd][Ii][Vv]                     { mkT $ TOpCodeSimple 0x14 }
<0>[Ff][Ss][Qq][Rr][Tt]                 { mkT $ TOpCodeSimple 0x15 }
<0>[Ff][Rr][Ee][Mm]                     { mkT $ TOpCodeSimple 0x16 }
<0>[Ff][Ii][Nn][Tt]                     { mkT $ TOpCodeSimple 0x17 }
<0>[Mm][Uu][Ll]                         { mkT $ TOpCode 0x18 }
<0>[Mm][Uu][Ll][Uu]                     { mkT $ TOpCode 0x1A }
<0>[Dd][Ii][Vv]                         { mkT $ TOpCode 0x1C }
<0>[Dd][Ii][Vv][Uu]                     { mkT $ TOpCode 0x1E }
<0>[Aa][Dd][Dd]                         { mkT $ TOpCode 0x20 }
<0>[Ll][Dd][Aa]                         { mkT $ TOpCode 0x22 }
<0>[Aa][Dd][Dd][Uu]                     { mkT $ TOpCode 0x22 }
<0>[Ss][Uu][Bb]                         { mkT $ TOpCode 0x24 }
<0>[Ss][Uu][Bb][Uu]                     { mkT $ TOpCode 0x26 }
<0>2[Aa][Dd][Dd][Uu]                    { mkT $ TOpCode 0x28 }
<0>4[Aa][Dd][Dd][Uu]                    { mkT $ TOpCode 0x2A }
<0>8[Aa][Dd][Dd][Uu]                    { mkT $ TOpCode 0x2C }
<0>16[Aa][Dd][Dd][Uu]                   { mkT $ TOpCode 0x2E }
<0>[Cc][Mm][Pp]                         { mkT $ TOpCode 0x30 }
<0>[Cc][Mm][Pp][Uu]                     { mkT $ TOpCode 0x32 }
<0>[Nn][Ee][Gg]                         { mkT $ TOpCode 0x34 }
<0>[Nn][Ee][Gg][Uu]                     { mkT $ TOpCode 0x36 }
<0>[Ss][Ll]                             { mkT $ TOpCode 0x38 }
<0>[Ss][Ll][Uu]                         { mkT $ TOpCode 0x3A }
<0>[Ss][Rr]                             { mkT $ TOpCode 0x3C }
<0>[Ss][Rr][Uu]                         { mkT $ TOpCode 0x3E }
<0>[Bb][Nn]                             { mkT $ TOpCodeSimple 0x40 }
<0>[Bb][Zz]                             { mkT $ TOpCodeSimple 0x42 }
<0>[Bb][Pp]                             { mkT $ TOpCodeSimple 0x44 }
<0>[Bb][Oo][Dd]                         { mkT $ TOpCodeSimple 0x46 }
<0>[Bb][Nn][Nn]                         { mkT $ TOpCodeSimple 0x48 }
<0>[Bb][Nn][Zz]                         { mkT $ TOpCodeSimple 0x4A }
<0>[Bb][Nn][Pp]                         { mkT $ TOpCodeSimple 0x4C }
<0>[Bb][Ee][Vv]                         { mkT $ TOpCodeSimple 0x4E }
<0>[Pp][Bb][Nn]                         { mkT $ TOpCodeSimple 0x50 }
<0>[Pp][Bb][Zz]                         { mkT $ TOpCodeSimple 0x52 }
<0>[Pp][Bb][Pp]                         { mkT $ TOpCodeSimple 0x54 }
<0>[Pp][Bb][Oo][Dd]                     { mkT $ TOpCodeSimple 0x56 }
<0>[Pp][Bb][Nn][Nn]                     { mkT $ TOpCodeSimple 0x58 }
<0>[Pp][Bb][Nn][Zz]                     { mkT $ TOpCodeSimple 0x5A }
<0>[Pp][Bb][Nn][Pp]                     { mkT $ TOpCodeSimple 0x5C }
<0>[Pp][Bb][Ee][Vv]                     { mkT $ TOpCodeSimple 0x5E }
<0>[Cc][Ss][Nn]                         { mkT $ TOpCode 0x60 }
<0>[Cc][Ss][Zz]                         { mkT $ TOpCode 0x62 }
<0>[Cc][Ss][Pp]                         { mkT $ TOpCode 0x64 }
<0>[Cc][Ss][Oo][Dd]                     { mkT $ TOpCode 0x66 }
<0>[Cc][Ss][Nn][Nn]                     { mkT $ TOpCode 0x68 }
<0>[Cc][Ss][Nn][Zz]                     { mkT $ TOpCode 0x6A }
<0>[Cc][Ss][Nn][Pp]                     { mkT $ TOpCode 0x6C }
<0>[Cc][Ss][Ee][Vv]                     { mkT $ TOpCode 0x6E }
<0>[Zz][Ss][Nn]                         { mkT $ TOpCode 0x70 }
<0>[Zz][Ss][Zz]                         { mkT $ TOpCode 0x72 }
<0>[Zz][Ss][Pp]                         { mkT $ TOpCode 0x74 }
<0>[Zz][Ss][Oo][Dd]                     { mkT $ TOpCode 0x76 }
<0>[Zz][Ss][Nn][Nn]                     { mkT $ TOpCode 0x78 }
<0>[Zz][Ss][Nn][Zz]                     { mkT $ TOpCode 0x7A }
<0>[Zz][Ss][Nn][Pp]                     { mkT $ TOpCode 0x7C }
<0>[Zz][Ss][Ee][Vv]                     { mkT $ TOpCode 0x7E }
<0>[Ll][Dd][Bb]                         { mkT $ TOpCode 0x80 }
<0>[Ll][Dd][Bb][Uu]                     { mkT $ TOpCode 0x82 }
<0>[Ll][Dd][Ww]                         { mkT $ TOpCode 0x84 }
<0>[Ll][Dd][Ww][Uu]                     { mkT $ TOpCode 0x86 }
<0>[Ll][Dd][Tt]                         { mkT $ TOpCode 0x88 }
<0>[Ll][Dd][Tt][Uu]                     { mkT $ TOpCode 0x8A }
<0>[Ll][Dd][Oo]                         { mkT $ TOpCode 0x8C }
<0>[Ll][Dd][Oo][Uu]                     { mkT $ TOpCode 0x8E }
<0>[Ll][Dd][Ss][Ff]                     { mkT $ TOpCode 0x90 }
<0>[Ll][Dd][Hh][Tt]                     { mkT $ TOpCode 0x92 }
<0>[Cc][Ss][Ww][Aa][Pp]                 { mkT $ TOpCode 0x94 }
<0>[Ll][Dd][Uu][Nn][Cc]                 { mkT $ TOpCode 0x96 }
<0>[Ll][Dd][Vv][Tt][Ss]                 { mkT $ TOpCode 0x98 }
<0>[Pp][Rr][Ee][Ll][Dd]                 { mkT $ TOpCode 0x9A }
<0>[Pp][Rr][Ee][Gg][Oo]                 { mkT $ TOpCode 0x9C }
<0>[Gg][Oo]                             { mkT $ TOpCode 0x9E }
<0>[Ss][Tt][Bb]                         { mkT $ TOpCode 0xA0 }
<0>[Ss][Tt][Bb][Uu]                     { mkT $ TOpCode 0xA2 }
<0>[Ss][Tt][Ww]                         { mkT $ TOpCode 0xA4 }
<0>[Ss][Tt][Ww][Uu]                     { mkT $ TOpCode 0xA6 }
<0>[Ss][Tt][Tt]                         { mkT $ TOpCode 0xA8 }
<0>[Ss][Tt][Tt][Uu]                     { mkT $ TOpCode 0xAA }
<0>[Ss][Tt][Oo]                         { mkT $ TOpCode 0xAC }
<0>[Ss][Tt][Oo][Uu]                     { mkT $ TOpCode 0xAE }
<0>[Ss][Tt][Ss][Ff]                     { mkT $ TOpCode 0xB0 }
<0>[Ss][Tt][Hh][Tt]                     { mkT $ TOpCode 0xB2 }
<0>[Ss][Tt][Cc][Oo]                     { mkT $ TOpCode 0xB4 }
<0>[Ss][Tt][Uu][Nn][Cc]                 { mkT $ TOpCode 0xB6 }
<0>[Ss][Yy][Nn][Cc][Dd]                 { mkT $ TOpCode 0xB8 }
<0>[Pp][Rr][Ee][Ss][Tt]                 { mkT $ TOpCode 0xBA }
<0>[Ss][Yy][Nn][Cc][Ii][Dd]             { mkT $ TOpCode 0xBC }
<0>[Pp][Uu][Ss][Hh][Gg][Oo]             { mkT $ TOpCode 0xBE }
<0>[Oo][Rr]                             { mkT $ TOpCode 0xC0 }
<0>[Oo][Rr][Nn]                         { mkT $ TOpCode 0xC2 }
<0>[Nn][Oo][Rr]                         { mkT $ TOpCode 0xC4 }
<0>[Xx][Oo][Rr]                         { mkT $ TOpCode 0xC6 }
<0>[Aa][Nn][Dd]                         { mkT $ TOpCode 0xC8 }
<0>[Aa][Nn][Dd][Nn]                     { mkT $ TOpCode 0xCA }
<0>[Nn][Aa][Nn][Dd]                     { mkT $ TOpCode 0xCC }
<0>[Nn][Xx][Oo][Rr]                     { mkT $ TOpCode 0xCE }
<0>[Bb][Dd][Ii][Ff]                     { mkT $ TOpCode 0xD0 }
<0>[Ww][Dd][Ii][Ff]                     { mkT $ TOpCode 0xD2 }
<0>[Tt][Dd][Ii][Ff]                     { mkT $ TOpCode 0xD4 }
<0>[Oo][Dd][Ii][Ff]                     { mkT $ TOpCode 0xD6 }
<0>[Mm][Uu][Xx]                         { mkT $ TOpCode 0xD8 }
<0>[Ss][Aa][Dd][Dd]                     { mkT $ TOpCode 0xDA }
<0>[Mm][Oo][Rr]                         { mkT $ TOpCode 0xDC }
<0>[Mm][Xx][Oo][Rr]                     { mkT $ TOpCode 0xDE }
<0>[Ss][Ee][Tt][Hh]                     { mkT $ TOpCodeSimple 0xE0 }
<0>[Ss][Ee][Tt][Mm][Hh]                 { mkT $ TOpCodeSimple 0xE1 }
<0>[Ss][Ee][Tt][Mm][Ll]                 { mkT $ TOpCodeSimple 0xE2 }
<0>[Ss][Ee][Tt][Ll]                     { mkT $ TOpCodeSimple 0xE3 }
<0>[Ii][Nn][Cc][Hh]                     { mkT $ TOpCodeSimple 0xE4 }
<0>[Ii][Nn][Cc][Mm][Hh]                 { mkT $ TOpCodeSimple 0xE5 }
<0>[Ii][Nn][Cc][Mm][Ll]                 { mkT $ TOpCodeSimple 0xE6 }
<0>[Ii][Nn][Cc][Ll]                     { mkT $ TOpCodeSimple 0xE7 }
<0>[Oo][Rr][Hh]                         { mkT $ TOpCodeSimple 0xE8 }
<0>[Oo][Rr][Mm][Hh]                     { mkT $ TOpCodeSimple 0xE9 }
<0>[Oo][Rr][Mm][Ll]                     { mkT $ TOpCodeSimple 0xEA }
<0>[Oo][Rr][Ll]                         { mkT $ TOpCodeSimple 0xEB }
<0>[Aa][Nn][Dd][Nn][Hh]                 { mkT $ TOpCodeSimple 0xEC }
<0>[Aa][Nn][Dd][Nn][Mm][Hh]             { mkT $ TOpCodeSimple 0xED }
<0>[Aa][Nn][Dd][Nn][Mm][Ll]             { mkT $ TOpCodeSimple 0xEE }
<0>[Aa][Nn][Dd][Nn][Ll]                 { mkT $ TOpCodeSimple 0xEF }
<0>[Jj][Mm][Pp]                         { mkT $ TOpCodeSimple 0xF0 }
<0>[Pp][Uu][Ss][Hh][Jj]                 { mkT $ TOpCodeSimple 0xF2 }
<0>[Gg][Ee][Tt][Aa]                     { mkT $ TOpCodeSimple 0xF4 }
<0>[Pp][Uu][Tt]                         { mkT $ TOpCode 0xF6 }
<0>[Pp][Oo][Pp]                         { mkT $ TOpCodeSimple 0xF8 }
<0>[Rr][Ee][Ss][Uu][Mm][Ee]             { mkT $ TOpCodeSimple 0xF9 }
<0>[Ss][Aa][Vv][Ee]                     { mkT $ TOpCodeSimple 0xFA }
<0>[Ss][Yy][Nn][Cc]                     { mkT $ TOpCodeSimple 0xFC }
<0>[Ss][Ww][Yy][Mm]                     { mkT $ TOpCodeSimple 0xFD }
<0>[Gg][Ee][Tt]                         { mkT $ TOpCodeSimple 0xFE }
<0>[Tt][Rr][Ii][Pp]                     { mkT $ TOpCodeSimple 0xFF }
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
<0>\'.\'                                { mkChar }
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
            | TLocalForwardOperand { tlfo :: Int }
            | TLocalBackwardOperand { tlbo :: Int }
            | TLocalLabel { tll :: Int }
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
            | TOpCodeSimple { soc_value :: Int }
            | TDataSegment
            | TAtSign
            | TComma
            | TPlus
            | TMult
            | TMinus
            | TDivide
            | TOpenParen
            | TCloseParen
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

mkLocalLabel input length = mkT (TLocalLabel val) input length
    where val = read (getStr input 1) :: Int

mkChar input length = mkT (TByteLiteral val) input length
    where val = (getStr input 2) !! 1 :: Char

mkLocalForwardOperand input length = mkT (TLocalForwardOperand val) input length
    where val = read (getStr input 1) :: Int

mkLocalBackwardOperand input length = mkT (TLocalBackwardOperand val) input length
    where val = read (getStr input 1) :: Int

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
