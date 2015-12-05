{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module HelloSpec (
  spec,
  app
) where

import           Control.Monad.State (State, execState, gets, modify)
import           Prelude             hiding (readFile)
import           Test.Hspec          (Spec, describe, it, shouldBe)

import           Hello               (app)
import           TheOutsideWorld     (TheOutsideWorld(..))

data FakeFile = FakeFile { contents :: String } deriving (Eq, Show)

data TestData = TestData { readFileResult :: FakeFile
                         , timerResult    :: Double
                         , cmdLineArgs    :: [String]
                         , consoleWrites  :: [String] } deriving (Eq, Show)

instance TheOutsideWorld (State TestData) where

  -- times a computation, providing a tuple of duration, result
  measureTime op = do
    duration <- gets timerResult
    result   <- op
    return (duration, result)

  -- read command line arguments
  getArgs = gets cmdLineArgs

  -- capture output to State
  emit arg = modify $ \state ->
    state { consoleWrites = consoleWrites state ++ [arg] }
  --
  -- a file-reading stub that's always successful
  readFile _ = gets readFileResult >>= return . contents

spec :: Spec
spec = do
  let state = TestData { readFileResult = FakeFile "Rupert"
                       , timerResult = 1503
                       , cmdLineArgs = ["config.txt"]
                       , consoleWrites = [] }

  describe "app" $
    it "provides an example of testing against a stubbed interface in Haskell" $
      consoleWrites (execState app state) `shouldBe` ["Hello, Rupert!", "1503.00000 milliseconds"]
