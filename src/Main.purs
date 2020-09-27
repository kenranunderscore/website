module Main where

import Prelude

import Data.Maybe (Maybe (..))
import Effect (Effect)
import Halogen as Halogen
import Halogen.Aff as Aff
import Halogen.HTML as Html
import Halogen.HTML.Events as Events
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = Aff.runHalogenAff do
  body <- Aff.awaitBody
  runUI component unit body

data Action = Hello

component =
  Halogen.mkComponent
  { initialState
  , render
  , eval : Halogen.mkEval (Halogen.defaultEval { handleAction = handleAction })
  }
  where
    initialState _ = "foo"
    render state =
      Html.button [ Events.onClick \_ -> Just Hello ] [ Html.text state ]
    handleAction = case _ of
      Hello -> Halogen.modify_ \state -> "Hello!"
