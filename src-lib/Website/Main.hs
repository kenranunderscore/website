{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DataKinds #-}
module Website.Main (main) where

import Servant
import Servant.API.Generic
import Servant.HTML.Lucid (HTML)
import Lucid qualified as L
import Lucid.Base qualified as L
import Network.Wai.Handler.Warp qualified as Warp

type Html = L.Html ()

data Routes' mode = MkRoutes
  { getIndex :: mode :- Get '[HTML] Html
  , foobar :: mode :- "foobar" :> Get '[HTML] Html
  , static :: mode :- "resources" :> Raw
  }
  deriving stock (Generic)

type Routes = NamedRoutes Routes'

main :: IO ()
main = do
  Warp.run 8080 $ serve (Proxy @Routes) server
  where
    server = MkRoutes { getIndex = getIndexHandler
                      , foobar = pure $ L.p_ "HI NOW"
                      , static = serveDirectoryWebApp "./resources" }

hxGet = L.makeAttribute "hx-get"
hxTrigger = L.makeAttribute "hx-trigger"
hxTarget = L.makeAttribute "hx-target"
hxSwap = L.makeAttribute "hx-swap"

getIndexHandler :: Handler Html
getIndexHandler = pure $ do
  L.head_ $ L.script_ [L.src_ "./resources/htmx.min.js"] (mempty :: Html)
  L.body_ $ do
    L.p_ "Lucid with htmx, fuck yeah"
    L.div_ [L.id_ targetId] "We should swap this out when clicking the button below"
    L.button_ [hxGet "/foobar", hxTarget ("#" <> targetId), hxSwap "innerHTML", hxTrigger "click"] "click me!"
  where
    targetId = "the-target"
