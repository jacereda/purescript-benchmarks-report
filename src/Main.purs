module Main where

import Prelude

import Chart as Chart
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, logShow)
import DOM.HTML (window)
import DOM.HTML.Location (search)
import DOM.HTML.Window (location)
import Data.Either (Either(..))
import Data.String (drop)
import Global (decodeURIComponent)
import Halogen.Aff (HalogenEffects, awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)
import Simple.JSON (readJSON)

main :: forall e. Eff (HalogenEffects (Chart.Effects (console :: CONSOLE | e))) Unit
main = do
  args <- window >>= location >>= search
  case readJSON $ decodeURIComponent $ drop 1 args of
      Right br -> runHalogenAff do
        body <- awaitBody
        runUI Chart.component br body
      Left e -> logShow e 
