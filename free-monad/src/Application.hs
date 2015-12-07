{-# LANGUAGE GADTs #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Application (
  Action(..),
  HelloProgram,
  program, 
  run
) where

import           Control.Monad.Operational
import           Prelude            hiding (putStrLn, readFile)
import qualified System.Environment (getArgs)
import qualified Prelude            (putStrLn, readFile)
import qualified System.Exit        (exitSuccess)
import qualified System.TimeIt      (timeItT)

data Action a where
  ExitSuccess :: Action ()
  GetArgs :: Action [String]
  PutStrLn :: String -> Action ()
  ReadFile :: String -> Action String
  TimeItT :: HelloProgram a -> Action (Double, a)

type HelloProgram a = Program Action a

getArgs :: HelloProgram [String]
getArgs = singleton GetArgs

putStrLn :: String -> HelloProgram ()
putStrLn = singleton . PutStrLn

readFile :: String -> HelloProgram String
readFile = singleton . ReadFile

timeItT :: HelloProgram a -> HelloProgram (Double, a)
timeItT = singleton . TimeItT

exitSuccess :: HelloProgram ()
exitSuccess = singleton ExitSuccess

interpretIO :: HelloProgram a -> IO a
interpretIO = interpretWithMonad go
  where 
    go :: forall a. Action a -> IO a
    go (GetArgs) = System.Environment.getArgs
    go (ReadFile str) = Prelude.readFile str
    go (PutStrLn str) = Prelude.putStrLn str
    go (ExitSuccess) = System.Exit.exitSuccess
    go (TimeItT program') = System.TimeIt.timeItT $ interpretIO program'

program :: HelloProgram ()
program = do
  (duration,_) <- timeItT $ do
    (path:_) <- getArgs
    target <- readFile path
    putStrLn ("target: " ++ target)
  putStrLn ("duration: " ++ (show duration))
  exitSuccess

run :: IO ()
run = interpretIO program