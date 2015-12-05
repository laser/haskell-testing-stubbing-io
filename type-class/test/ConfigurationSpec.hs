{-# LANGUAGE FlexibleInstances    #-}

module ConfigurationSpec (
  spec
) where

import           Control.Monad.Reader (Reader, asks, runReader)
import           Prelude              hiding (readFile)
import           Test.Hspec           (Spec, describe, it, shouldBe)

import           Configuration        (getTarget)
import           TheOutsideWorld      (TheOutsideWorld(..))

newtype FileContents = FileContents { unFileContents :: String }

instance TheOutsideWorld (Reader FileContents) where
  readFile _ = asks unFileContents

spec :: Spec
spec = do
  describe "getTarget" $
    it "delegates to readFile" $
      runReader (getTarget "config.txt") (FileContents "Rupert") `shouldBe` "Rupert"
