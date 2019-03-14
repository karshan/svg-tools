module Lib where

import Data.Bool (bool)
import Text.XML.Light

processXML :: (Content -> [Content]) -> String -> String
processXML f = concatMap showContent . concatMap go . parseXML
    where
        go :: Content -> [Content]
        go (Elem e) = [Elem $ e { elContent = concatMap f (elContent e) }]
        go c = f c

hasAttr :: String -> Element -> Bool
hasAttr attr e = not $ null $ filter (\a -> attr == qName (attrKey a) && attrVal a /= "none") $ elAttribs e

isStrokeFill :: Element -> Bool
isStrokeFill e = hasAttr "stroke" e || hasAttr "fill" e

mkAttr :: String -> String -> Attr
mkAttr key val = Attr (QName key Nothing Nothing) val

addAttr :: Attr -> Element -> Element
addAttr attr e = e { elAttribs = attr:elAttribs e }

removeAttr :: String -> Element -> Element
removeAttr attr e = e { elAttribs = filter (\a -> attrKey a /= QName attr Nothing Nothing) (elAttribs e) }

addIconClasses :: Content -> [Content]
addIconClasses (Elem e) = return $
    Elem $ (removeAttr "id" .
        bool (removeAttr "stroke-width") (addAttr (mkAttr "class" "icon_svg-stroke icon_svg-fill")) (isStrokeFill e)) e
addIconClasses c = [c]
