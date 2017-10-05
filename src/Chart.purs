module Chart where

import Prelude

import Control.Monad.Aff (Aff)
import DOM (DOM)
import DOM.HTML.HTMLElement (offsetWidth)
import Data.Int (round)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Halogen as H
import Halogen.ECharts as EC
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Scatter (scatter)
import Types (BenchRes)

type State = { width :: Int, br :: BenchRes }
data Query a = HandleEChartsMessage EC.EChartsMessage a
type ChildQuery = EC.EChartsQuery
type ChildSlot = Unit
type Effects e = EC.EChartsEffects (dom :: DOM | e)

component :: forall e. H.Component HH.HTML Query BenchRes Void (Aff (Effects e))
component =
  H.parentComponent
    { initialState: initialState
    , render
    , eval
    , receiver: const Nothing
    }
  where

  initialState :: BenchRes -> State
  initialState br = { width: 0, br: br }

  render :: State -> H.ParentHTML Query ChildQuery ChildSlot (Aff (Effects e))
  render state = HH.div [HP.ref (H.RefLabel "cont")] [ HH.slot unit (EC.echarts Nothing)
              ({width: state.width, height: (state.width * 9 / 16)} /\ unit)
              (Just <<< H.action <<< HandleEChartsMessage)
            ]

  eval :: Query ~> H.ParentDSL State Query ChildQuery ChildSlot Void (Aff (Effects e))
  eval (HandleEChartsMessage EC.Initialized next) = do
    me <- H.getHTMLElementRef (H.RefLabel "cont")
    width <- case me of
      Just e -> H.liftEff (offsetWidth e)
      _ -> pure 0.0
    H.modify _{ width = round width }      
    state <- H.get
    void $ H.query unit $ H.action $ EC.Set $ scatter state.br
    pure next
  eval (HandleEChartsMessage _ next) = pure next
