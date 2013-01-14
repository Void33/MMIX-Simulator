module Parser where
import Text.Regex.Posix

parseHeader :: String -> [String]
parseHeader hdr = [hdr]

parseHeaderItem :: String -> String -> (Int, Int)
parseHeaderItem hdr pat =  hdr =~ pat :: (Int, Int)