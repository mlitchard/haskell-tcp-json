module Tcp where

import Network
import System.Environment
import System.IO
import Control.Concurrent
import qualified Data.ByteString.Lazy.Char8 as BS

import Json

handleSocket handler = withSocketsDo $ do
  args <- getArgs
  let port = fromIntegral (read $ head args :: Int)
  sock <- listenOn $ PortNumber port
  putStrLn $ "Listening on " ++ (head args)
  sockHandler sock handler

sockHandler sock handler = do
  (handle, _, _) <- accept sock
  hSetBuffering handle NoBuffering
  forkIO $ handleMessage handler handle
  sockHandler sock handler

handleMessage handler handle = do
  line <- hGetLine handle
  hPutStrLn handle ""
  hPutStrLn handle "Here is a record as JSON:"
  hPutStrLn handle $ BS.unpack $ asJson $ Response "morjens"
  hPutStrLn handle ""
  hPutStrLn handle "Here is a JSON as record:"
  hPutStrLn handle $ show $ handler $ BS.pack line
  hClose handle
