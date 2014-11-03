module Main where

import MMix_Lexer
import Text.Printf

main :: IO()
main = undefined

--contents "/home/steveedmans/development/MMIX-Simulator/Sample/hail1.mms"
--contents "/home/steveedmans/development/MMIX-Simulator/Sample/Simple.mms"

contents fs = do
    x <- readFile fs
    printf "%s\n" x
    let s = tokens x
    return s
