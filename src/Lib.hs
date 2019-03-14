module Lib where

import Data.Bool (bool)
import Text.XML.Light

type CFilter = Content -> [Content]

o :: CFilter -> CFilter -> CFilter
f `o` g = concatMap f . g

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

removeAttr' :: String -> CFilter
removeAttr' attr (Elem e) = [Elem $ e { elAttribs = filter (\a -> attrKey a /= QName attr Nothing Nothing) (elAttribs e) }]
removeAttr' _ c = [c]

addIconClasses :: CFilter
addIconClasses c@(Elem e)
    | isStrokeFill e = [Elem (addAttr (mkAttr "class" "icon_svg-stroke icon_svg-fill") e)]
    | otherwise = [c]
addIconClasses c = [c]

removeUselessTags :: CFilter
removeUselessTags c@(Elem e) = let n = qName (elName e) in bool [c] [] (n `elem` ["title", "desc", "defs"])
removeUselessTags c = [c]

mkIcon :: String -> String
mkIcon = processXML (addIconClasses `o` removeAttr' "stroke-width" `o` removeAttr' "id" `o` removeUselessTags)
