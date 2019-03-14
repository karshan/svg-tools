module Main where

import System.Environment (getArgs)
import Lib (processXML, mkIcon)

main :: IO ()
main = do
    (f:_) <- getArgs
    putStr . mkIcon =<< readFile f
