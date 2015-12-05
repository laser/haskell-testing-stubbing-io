{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module ConfigurationSpec (
  spec
) where

import           Control.Monad.Reader (Reader, asks, runReader)
import           Prelude              hiding (readFile)
import           Test.Hspec           (Spec, describe, it, shouldBe)

import           Configuration        (Configuration (..), getTarget)

data FakeFile = FakeFile { contents :: String } deriving (Eq, Show)

instance Configuration (Reader FakeFile) where

  -- a file-reading stub that's always successful
  readFile _ = asks contents

spec :: Spec
spec = do
  describe "getTarget" $
    it "provides an example of testing against a stubbed interface in Haskell" $
      runReader (getTarget "config.txt") (FakeFile "Rupert") `shouldBe` "Rupert"
