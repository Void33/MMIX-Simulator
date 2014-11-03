{
module MMix_Lexer where

import Data.Char (chr)
import Numeric (readDec)
import Numeric (readHex)

import Debug.Trace
}

%wrapper "monad"

$digit    = 0-9            -- digits
$alpha    = [a-zA-Z]       -- alphabetic characters
$hexdigit = [0-9a-eA-E]    -- hexadecimal digits

tokens :-

<0>$white+		  	                    ;
<0>[Gg][Rr][Ee][Gg]                     { mkT TGREG }
<0>[Ll][Oo][Cc]                         { mkT TLOC }
<0>[Bb][Yy][Tt][Ee]                     { mkT TByte }
<0>\@                                   { mkT TAtSign }
<0>\#$hexdigit+                         { mkHex }
<0>\$$digit+                            { mkRegister }
<0>$digit+	                            { mkInteger }
<0>\,                                   { mkT TComma }
<0>\"                                   { mkT TStringLiteral `andBegin` string }
<string>\"                              { endComment `andBegin` 0 }
<string>[^\"]            	            { word }
<0>$alpha [$alpha $digit \_ \']*        { mkIdentifier }
<0>.                                    { mkError }

{
data Token = LEOF
            | TIdentifier { tid_name :: String }
            | TError { terr_text :: String }
            | TInteger { tint_value :: Int }
            | THexLiteral { thex_value :: Int }
            | TRegister { treg_value :: Int }
            | TStringLiteral
            | TByte
            | TGREG
            | TLOC
            | TAtSign
            | TComma
            | TByteLiteral Char
            | W String
            | CommentStart
            | CommentEnd
            | CommentBody String
            deriving (Show,Eq)

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
mkT token _ _ = trace ("Tracing: " ++ show token )
                                        return $ token

alexEOF = return LEOF

startComment _ _ = return CommentStart
endComment _ _   = return CommentEnd

tokens str = runAlex str $ do
               let loop = do tok <- alexMonadScan
                             if tok == LEOF
                               then return []
                               else do toks <- loop
                                       return $ tok : toks
               loop
}
