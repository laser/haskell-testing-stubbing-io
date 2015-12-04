{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module HelloSpec (spec, app) where

import           Control.Monad.State (State, execState, gets, modify)
import           Prelude             hiding (readFile)
import           Test.Hspec          (Spec, describe, it, shouldBe)

import           Hello               (TheOutsideWorld (..), app)

data FakeFile = FakeFile { contents :: String } deriving (Eq, Show)

data Stubs = Stubs { readFileResult :: FakeFile
                   , timerResult    :: Double
                   , cmdLineArgs    :: [String]
                   , consoleWrites  :: [String] } deriving (Eq, Show)

instance TheOutsideWorld (State Stubs) where

  -- a file-reading stub that's always successful
  readFile pathRequested = gets readFileResult >>= return . contents

  -- times a computation, providing a tuple of duration, result
  time op = do
    duration <- gets timerResult
    result   <- op
    return (duration, result)

  -- read command line arguments
  getArgs = gets cmdLineArgs

  -- capture output to State
  emit s = modify $ \bindings ->
    bindings { consoleWrites = consoleWrites bindings ++ [s] }

spec :: Spec
spec = do
  let stubs = Stubs { readFileResult = FakeFile "Rupert"
                    , timerResult = 15.0
                    , cmdLineArgs = ["config.txt"]
                    , consoleWrites = [] }

  describe "app" $
    it "provides an example of testing against a stubbed interface in Haskell" $
      consoleWrites (execState app stubs) `shouldBe` ["hello, Rupert", "It took: 15.0"]
