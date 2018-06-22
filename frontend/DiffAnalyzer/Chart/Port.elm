port module DiffAnalyzer.Chart.Port exposing (..)

import DiffAnalyzer.Chart.Types exposing (..)


port drawChart : List Delta -> Cmd msg
