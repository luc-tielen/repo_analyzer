module DiffAnalyzer.Types exposing (..)

import DiffAnalyzer.FileMenu.Types exposing (..)
import DiffAnalyzer.Chart.Types exposing (..)


type alias Config =
    { apiUrl : String }


type alias Model =
    { fileMenu : FileMenuModel, chart : ChartModel, config : Config }


type Msg
    = FileMenuMsg FileMenuMsg
    | ChartMsg ChartMsg
