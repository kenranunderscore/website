{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DataKinds #-}
module Website.Main (main) where

import Servant
import Servant.API.Generic
import Servant.HTML.Lucid (HTML)
import Lucid qualified as L
import Network.Wai.Handler.Warp qualified as Warp

data Routes' mode = MkRoutes
  { getIndex :: mode :- Get '[HTML] (L.Html ())
  , static :: mode :- "resources" :> Raw
  }
  deriving stock (Generic)

type Routes = NamedRoutes Routes'

main :: IO ()
main = do
  Warp.run 8080 $ serve (Proxy @Routes) server
  where
    server = MkRoutes { getIndex = getIndexHandler
                      , static = serveDirectoryWebApp "./resources" }

getIndexHandler :: Handler (L.Html ())
getIndexHandler = pure $ do
  L.head_ $ L.script_ [L.src_ "./resources/htmx.min.js"] (mempty :: String)
  L.body_ $ L.p_ "Lucid with htmx, fuck yeah"
