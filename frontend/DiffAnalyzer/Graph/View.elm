module DiffAnalyzer.Graph.View exposing (view)

import DiffAnalyzer.Graph.Types exposing (..)
import DiffAnalyzer.Style exposing (..)
import Element exposing (..)
import Element.Events exposing (..)
import Element.Attributes exposing (..)
import Html exposing (Html)
import Time
import LineChart
import LineChart.Container as Container
import LineChart.Legends as Legends
import LineChart.Events as Events
import LineChart.Colors as Colors
import LineChart.Interpolation as Interpolation
import LineChart.Line as Line
import LineChart.Dots as Dots
import LineChart.Junk as Junk
import LineChart.Grid as Grid
import LineChart.Area as Area
import LineChart.Axis as Axis
import LineChart.Axis.Intersection as Intersection


view : GraphModel -> Element Styles variation GraphMsg
view model =
  case model.currentFile of
    Nothing -> empty
    Just file ->
      column None [ width fill, verticalCenter, padding 10 ] <|
          [ el (Text Title) [ center, paddingBottom 20 ] <| text file
          , html <| chart model
          , filterDeltasButton model
          ]

filterDeltasButton : GraphModel -> Element Styles variation GraphMsg
filterDeltasButton model =
  case model.filterMode of
    NoFilter ->
      let attrs = [ width (px 250), center, onClick <| ChangeFilterMode OnlyChanges ]
      in button Button attrs <| text "Show only changes for this file"
    OnlyChanges ->
      let attrs = [ width (px 250), center, onClick <| ChangeFilterMode NoFilter ]
      in button Button attrs <| text "Show entire history"

chart : GraphModel -> Html GraphMsg
chart model =
  let filteredDeltas = case model.filterMode of
        NoFilter -> model.deltas
        OnlyChanges -> List.filter isDeltaWithChanges model.deltas
      additions = List.map (\d -> (d.time, d.additions)) filteredDeltas
      deletions = List.map (\d -> (d.time, d.deletions)) filteredDeltas
  in LineChart.viewCustom chartConfig
     [ LineChart.line Colors.green Dots.circle "Additions" additions
     , LineChart.line Colors.red Dots.circle "Deletions" deletions
     ]

isDeltaWithChanges : Delta -> Bool
isDeltaWithChanges d = d.additions /= 0 || d.deletions /= 0

chartConfig : LineChart.Config (Time.Time, Int) GraphMsg
chartConfig =
  { x = Axis.time 1270 "Time" Tuple.first
  , y = Axis.default 450 "LOC" (Tuple.second >> toFloat)
  , container = containerConfig
  , interpolation = Interpolation.monotone
  , intersection = Intersection.atOrigin
  , events = Events.default
  , legends = Legends.none
  , dots = Dots.custom <| Dots.full 5
  , area = Area.default
  , line = Line.wider 3
  , grid = Grid.default
  , junk = Junk.default
  }

containerConfig : Container.Config GraphMsg
containerConfig =
  Container.custom
    { attributesHtml = []
    , attributesSvg = []
    , size = Container.relative
    , margin = Container.Margin 30 100 30 70
    , id = "deltas-chart"
    }

