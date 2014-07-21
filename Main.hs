{-# LANGUAGE OverloadedStrings #-}

import Control.Monad
import Control.Concurrent.Chan
import Control.Concurrent (forkIO, threadDelay)
import Network.HTTP.Types
import Network.Wai
import Network.Wai.EventSource
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.Gzip (gzip, def)
import Blaze.ByteString.Builder.Char.Utf8 (fromString)
import Data.Time.Clock.POSIX

app :: Chan ServerEvent -> Application
app chan request respond =
  case pathInfo request of
    []                           -> respond $ responseFile status200 [("Content-Type", "text/html")] "static/index.html" Nothing
    ["assets", "background.png"] -> respond $ responseFile status200 [("Content-Type", "image/png")] "static/background.png" Nothing
    ["build", "build.css"]       -> respond $ responseFile status200 [("Content-Type", "text/css")] "build/build.css" Nothing
    ["build", "build.js"]        -> respond $ responseFile status200 [("Content-Type", "application/javascript")] "build/build.js" Nothing
    ["eschan"]                   -> eventSourceAppChan chan request respond
    _                            -> error $ "unexpected pathInfo" ++ show (pathInfo request)

eventChan :: Chan ServerEvent -> IO ()
eventChan chan = forever $ do
  threadDelay 1000000
  time <- round `fmap` (* 1000) `fmap` getPOSIXTime
  writeChan chan (ServerEvent Nothing Nothing [fromString . show $ time])

main :: IO ()
main = do
  chan <- newChan
  _ <- forkIO . eventChan $ chan
  putStrLn $ "http://localhost:8080/"
  run 8080 (gzip def $ app chan)
