module DiffAnalyzer.Types exposing (..)

import DiffAnalyzer.FileMenu.Types exposing (..)
import DiffAnalyzer.Chart.Types exposing (..)


type alias Model =
    { fileMenu : FileMenuModel, chart : ChartModel }


type Msg
    = FileMenuMsg FileMenuMsg
    | ChartMsg ChartMsg
