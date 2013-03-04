import Control.Monad ( liftM )
import Data.List ( intersperse )
import Test.QuickCheck.Gen
import Test.QuickCheck.Arbitrary
import Test.QuickCheck.Property
import Test.QuickCheck.Test

splitFN_0 :: String -> (String, String)
splitFN_0 fn =
  let fn' = span (/= '.') . reverse $ fn
  in case (length (fst fn') == length fn) of
        True  -> (fn, "")
        False -> (reverse . drop 1 $ snd fn', ('.':) . reverse . fst $ fn')

joinFN_0 :: (String, String) -> String
joinFN_0 (name, ext) = name ++ ext

newtype Filename = FN { unFN :: String } deriving Show

instance Arbitrary Filename where
  arbitrary = do name <- elements ["foo", "bar", "baz"]
                 ext <- listOf $ elements ['a'..'z']
                 return (FN (name ++ "." ++ ext))
             
prop_filenames_are_roundtrippable_0 :: Filename -> Property
prop_filenames_are_roundtrippable_0 fnStr =
  property $ joinFN_0 (splitFN_0 fn) == fn
  where fn = unFN fnStr
  