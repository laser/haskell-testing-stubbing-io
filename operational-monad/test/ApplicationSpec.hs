{-# LANGUAGE GADTs #-}
{-# LANGUAGE ScopedTypeVariables #-}

module ApplicationSpec (
  spec,
) where

import           Control.Monad.Operational
import           Control.Monad.State (State, execState, gets, modify)
import           Test.Hspec          (Spec, describe, it, shouldBe)

import           Application         (Action(..), HelloProgram, program)

data FakeFile = FakeFile { contents :: String } deriving (Eq, Show)

data TestData = TestData { readFileResult :: FakeFile
                         , timerResult    :: Double
                         , cmdLineArgs    :: [String]
                         , consoleWrites  :: [String] } deriving (Eq, Show)

interpretState :: HelloProgram a -> State TestData a
interpretState program = interpretWithMonad go program
  where
    go :: forall a. Action a -> State TestData a
    go (ExitSuccess) = modify id
    go (GetArgs) = gets cmdLineArgs
    go (PutStrLn str) = modify $ \state ->
      state { consoleWrites = consoleWrites state ++ [str] }
    go (ReadFile str) = gets readFileResult >>= return . contents
    go (TimeItT program') = do
      duration <- gets timerResult
      result   <- interpretState program'
      return (duration, result)

spec :: Spec
spec = do
  let state = TestData { readFileResult = FakeFile "Rupert"
                       , timerResult = 1503
                       , cmdLineArgs = ["config.txt"]
                       , consoleWrites = [] }
  describe "program" $
    it "provides an example of testing using the Operational monad" $
      consoleWrites (execState (interpretState program) state) `shouldBe` ["target: Rupert","duration: 1503.0"]
