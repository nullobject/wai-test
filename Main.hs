{-# LANGUAGE OverloadedStrings #-}

import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.Chan (Chan, newChan, writeChan)
import Control.Monad (forever)
import Data.ByteString.Builder (string8)
import Data.Time.Clock.POSIX (getPOSIXTime)
import Network.HTTP.Types (status200, status404)
import Network.Wai (Application, Response, responseFile, responseLBS, rawPathInfo)
import Network.Wai.EventSource (ServerEvent(..), eventSourceAppChan)
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.Gzip (gzip, def)
import Network.Wai.Middleware.Static (addBase, staticPolicy)

app :: Chan ServerEvent -> Application
app chan request sendResponse =
  case rawPathInfo request of
    "/" -> sendResponse $ responseFile status200 [("Content-Type", "text/html")] "dist/index.html" Nothing
    "/eschan" -> eventSourceAppChan chan request sendResponse
    _         -> sendResponse $ notFound

notFound :: Response
notFound = responseLBS status404 [("Content-Type", "text/plain")] "404 - Not Found"

eventChan :: Chan ServerEvent -> IO ()
eventChan chan = forever $ do
  threadDelay 1000000
  time <- round `fmap` (* 1000) `fmap` getPOSIXTime
  writeChan chan (ServerEvent Nothing Nothing [string8 . show $ time])

main :: IO ()
main = do
  chan <- newChan
  _ <- forkIO . eventChan $ chan
  putStrLn $ "http://localhost:8080/"
  run 8080 (gzip def $ staticPolicy (addBase "dist") $ app chan)
