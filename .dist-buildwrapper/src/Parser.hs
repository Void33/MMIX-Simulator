module Parser where
import Text.Regex.Posix

parseHeader :: String -> [String]
parseHeader hdr = [hdr]

parseHeaderItem :: String -> (Int, Int)
parseHeaderItem hdr =  hdr =~ "OP( )*" :: (Int, Int)