{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module HelloSpec (
  spec,
  app
) where

import           Control.Monad.State (State, execState, gets, modify)
import           Prelude             hiding (readFile)
import           Test.Hspec          (Spec, describe, it, shouldBe)

import           Configuration       (Configuration (..))
import           Hello               (TheOutsideWorld (..), app)

data FakeFile = FakeFile { contents :: String } deriving (Eq, Show)

data TestState = TestState { readFileResult :: FakeFile
                           , timerResult    :: Double
                           , cmdLineArgs    :: [String]
                           , consoleWrites  :: [String] } deriving (Eq, Show)

instance TheOutsideWorld (State TestState) where

  -- times a computation, providing a tuple of duration, result
  time op = do
    duration <- gets timerResult
    result   <- op
    return (duration, result)

  -- read command line arguments
  getArgs = gets cmdLineArgs

  -- capture output to State
  emit arg = modify $ \state ->
    state { consoleWrites = consoleWrites state ++ [arg] }

instance Configuration (State TestState) where

  -- a file-reading stub that's always successful
  readFile _ = gets readFileResult >>= return . contents

spec :: Spec
spec = do
  let state = TestState { readFileResult = FakeFile "Rupert"
                        , timerResult = 15.0
                        , cmdLineArgs = ["config.txt"]
                        , consoleWrites = [] }

  describe "app" $
    it "provides an example of testing against a stubbed interface in Haskell" $
      consoleWrites (execState app state) `shouldBe` ["hello, Rupert", "It took: 15.0"]
