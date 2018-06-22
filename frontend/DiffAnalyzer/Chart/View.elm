module DiffAnalyzer.Chart.View exposing (view)

import DiffAnalyzer.Chart.Types exposing (..)
import DiffAnalyzer.Style exposing (..)
import Element exposing (..)
import Element.Events exposing (..)
import Element.Attributes exposing (..)
import Html exposing (Html)
import Html.Attributes as HA


view : ChartModel -> Element Styles variation ChartMsg
view model =
    let
        layout file =
            column None [ width fill, verticalCenter, padding 10 ] <|
                [ el (Text Title) [ center, paddingBottom 20 ] <| text file
                , chart
                , filterDeltasButton model
                ]
    in
        Maybe.map layout model.currentFile |> Maybe.withDefault empty


filterDeltasButton : ChartModel -> Element Styles variation ChartMsg
filterDeltasButton model =
    case model.filterMode of
        NoFilter ->
            let
                attrs =
                    [ width (px 250), center, onClick <| ChangeFilterMode OnlyChanges ]
            in
                button Button attrs <| text "Show only changes for this file"

        OnlyChanges ->
            let
                attrs =
                    [ width (px 250), center, onClick <| ChangeFilterMode NoFilter ]
            in
                button Button attrs <| text "Show entire history"


chart : Element Styles variation ChartMsg
chart =
    -- NOTE: the div is needed because of the way Elm virtual DOM works!
    -- Otherwise glitchy behavior occurs because Elm and JS both try rendering stuff.
    html <| Html.div [] <| [ Html.node "canvas" [ HA.id "deltas-chart" ] [] ]
