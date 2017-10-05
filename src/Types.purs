module Types where

type XYSample = Array {x :: Number, y :: Number}

type VarRes = { name :: String
              , a :: Number
              , b :: Number
              , r :: Number
              , xys :: XYSample
              }

type BenchRes = { name :: String
                , result :: Array VarRes
                }



