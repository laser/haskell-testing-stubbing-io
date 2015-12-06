module ApplicationSpec (
  spec,
) where

import           Test.Hspec          (Spec, describe, it, shouldBe)

import           Application         (run)

spec :: Spec
spec = do
  describe "run" $
    it "provides an example of testing using free monads" $
      1 `shouldBe` 1
