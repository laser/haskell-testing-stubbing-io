module Application (
  run
) where

import           Control.Monad.Free
import           Prelude            hiding (putStrLn, readFile)
import qualified System.Environment (getArgs)
import qualified Prelude            (putStrLn, readFile)
import qualified System.Exit        (exitSuccess)

data ActionF a
  = PutStrLn String a
  | GetArgs ([String] -> a)
  | ReadFile FilePath (String -> a)
  | ExitSuccess

instance Functor ActionF where
  fmap f (PutStrLn str x) = PutStrLn str (f x)
  fmap f (GetArgs k) = GetArgs (f . k)
  fmap f (ReadFile path k) = ReadFile path (f . k)
  fmap _ ExitSuccess = ExitSuccess

type Action = Free ActionF

putStrLn :: String -> Action ()
putStrLn str = liftF $ PutStrLn str ()

getArgs :: Action [String]
getArgs = liftF $ GetArgs id

readFile :: FilePath -> Action String
readFile path = liftF $ ReadFile path id

exitSuccess :: Action a
exitSuccess = liftF ExitSuccess

interpretIO :: Action a -> IO a
interpretIO (Pure x)                   = return x
interpretIO (Free (PutStrLn str next)) = Prelude.putStrLn str       >>  interpretIO next
interpretIO (Free (GetArgs f))         = System.Environment.getArgs >>= interpretIO . f
interpretIO (Free (ReadFile path f))   = Prelude.readFile path      >>= interpretIO . f
interpretIO (Free ExitSuccess)         = System.Exit.exitSuccess

program :: Action ()
program = do
  (a:_) <- getArgs
  putStrLn ("Got " ++ a ++ " as an argument...")
  contents <- readFile a
  putStrLn ("File contents: " ++ contents)
  exitSuccess

run :: IO ()
run = interpretIO program
