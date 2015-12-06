module Application (
  run
) where

import           Control.Monad.Free
import           Prelude            hiding (putStrLn, readFile)
import qualified System.Environment (getArgs)
import qualified Prelude            (putStrLn, readFile)
import qualified System.Exit        (exitSuccess)
import qualified System.TimeIt      (timeItT)
import qualified Text.Printf        (printf)


{-

OPEN QUESTIONS
==============

How do I create an `ActionF` constructor that could be used to represent the
`timeItT` function (which has type `IO a -> IO (Double, a)`)?

What would fmap look like for that constructor?

-}

data ActionF a
  = PutStrLn String a
  | GetArgs ([String] -> a)
  | ReadFile FilePath (String -> a)
  -- | MeasureTime (ActionF a) (ActionF (Double, a) -> a)
  | ExitSuccess

instance Functor ActionF where
  fmap f (PutStrLn str x) = PutStrLn str (f x)
  fmap f (GetArgs k) = GetArgs (f . k)
  fmap f (ReadFile path k) = ReadFile path (f . k)
  -- fmap f (MeasureTime op k) = MeasureTime (fmap f op) (f . k)
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

timeItT :: Action a -> Action (Double, a)
timeItT = undefined

interpretIO :: Action a -> IO a
interpretIO (Pure x)                   = return x
interpretIO (Free (PutStrLn str next)) = Prelude.putStrLn str       >>  interpretIO next
interpretIO (Free (GetArgs f))         = System.Environment.getArgs >>= interpretIO . f
interpretIO (Free (ReadFile path f))   = Prelude.readFile path      >>= interpretIO . f
-- interpretIO (Free (MeasureTime op f))  = System.TimeIt.timeItT op   >>= interpretIO . f
interpretIO (Free ExitSuccess)         = System.Exit.exitSuccess

makeReport :: Double -> String
makeReport = flip (++) " milliseconds" . Text.Printf.printf "%.5F"

program :: Action ()
program = do
  (duration,_) <- timeItT $ do
    (arg:_) <- getArgs
    putStrLn ("Got " ++ arg ++ " as an argument...")
    contents <- readFile arg
    putStrLn ("File contents: " ++ contents)
  putStrLn (makeReport duration)
  exitSuccess

run :: IO ()
run = interpretIO program
