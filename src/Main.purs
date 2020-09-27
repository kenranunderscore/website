module Main where

import Prelude

import Data.Maybe (Maybe (..))
import Effect (Effect)
import Halogen as Halogen
import Halogen.Aff as Aff
import Halogen.HTML (HTML)
import Halogen.HTML as Html
import Halogen.HTML.Events as Events
import Halogen.VDom.Driver (runUI)

type State = String

data Action = Hello

main :: Effect Unit
main = Aff.runHalogenAff do
  body <- Aff.awaitBody
  runUI component unit body

component :: forall query input output m. Halogen.Component HTML query input output m
component =
  Halogen.mkComponent
  { initialState
  , render
  , eval : Halogen.mkEval (Halogen.defaultEval { handleAction = handleAction })
  }

initialState :: forall input. input -> State
initialState _ = "foo"

render :: forall m. State -> Halogen.ComponentHTML Action () m
render state =
  Html.button [ Events.onClick \_ -> Just Hello ] [ Html.text state ]

handleAction
  :: forall output m. Action
  -> Halogen.HalogenM State Action () output m Unit
handleAction = case _ of
  Hello -> Halogen.modify_ \state -> "Hello!"
