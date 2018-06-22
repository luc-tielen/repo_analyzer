module DiffAnalyzer.View exposing (view)

import DiffAnalyzer.Types exposing (..)
import DiffAnalyzer.FileMenu.View as FMView
import DiffAnalyzer.Graph.View as GView
import DiffAnalyzer.Style exposing (..)
import Html exposing (Html)
import Element exposing (..)
import Element.Attributes exposing (..)


view : Model -> Html Msg
view model =
    Element.viewport styleSheet <|
        row None
            [ height (percent 100) ]
            [ FMView.view model.fileMenu |> Element.map FileMenuMsg
            , GView.view model.graph |> Element.map GraphMsg
            ]
