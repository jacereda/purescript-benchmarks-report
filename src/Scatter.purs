module Scatter where

import Prelude

import Types (BenchRes)
import Data.Traversable (for_)
import ECharts.Commands as E
import ECharts.Monad as EM
import ECharts.Types as ET
import ECharts.Types.Phantom as ETP


scatter ∷ BenchRes -> EM.DSL ETP.OptionI
scatter br = do
  E.title do
    E.text br.name
  E.tooltip do
    E.trigger ET.AxisTrigger
    E.showDelay 0.0
    E.axisPointer do
      E.shown
      E.pointerType ET.CrossPointer
--    E.zlevel 1
  E.xAxis do
    E.axisType ET.Value
    E.scale true
  E.yAxis do
    E.axisType ET.Value
    E.scale true
  E.legend do
    E.items $ map (ET.strItem <<< _.name) br.result <> map (ET.strItem <<< (\x -> x.name <> " line") ) br.result
  E.series do
    for_ br.result \vr -> do 
      E.scatter do
        E.name vr.name
        E.large true
        E.symbolSize 8
        E.items $ (\e -> ET.pairItem e.x e.y) <$> vr.xys
      E.line do
        E.name $ vr.name <> " line"
        E.hoverAnimationEnabled false
        E.showSymbol false
        E.items $ (\e -> ET.pairItem e.x (vr.a + e.x * vr.b)) <$> vr.xys

