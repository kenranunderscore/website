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
  { getIndex :: mode :- "foo" :> Get '[HTML] (L.Html ())
  }
  deriving stock (Generic)

type Routes = NamedRoutes Routes'

main :: IO ()
main = do
  Warp.run 8080 $ serve (Proxy @Routes) server
  where
    server = MkRoutes { getIndex = getIndexHandler }

getIndexHandler :: Handler (L.Html ())
getIndexHandler = pure $ do
  L.p_ $ L.b_ "Hi from Lucid!"
