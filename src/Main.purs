module Main where

import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)
import Prelude

type State = { enabled :: Boolean }

data Action = Toggle

comp :: forall q i o m. H.Component q i o m
comp = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
  }

initialState :: forall i. i -> State
initialState _ = { enabled: false }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  let label = if state.enabled then "on" else "off"
  in HH.button [ HP.title label, HE.onClick \_ -> Toggle ] [ HH.text label ]

handleAction :: forall o m. Action -> H.HalogenM State Action () o m Unit
handleAction = case _ of
  Toggle ->
    H.modify_ \st -> st { enabled = not st.enabled }

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI comp unit body
