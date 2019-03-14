module Main where

import System.Environment (getArgs)
import Lib (processXML, addIconClasses)

main :: IO ()
main = do
    (f:_) <- getArgs
    putStr . processXML addIconClasses =<< readFile f
