module DiffAnalyzer.Graph.View exposing (view)

import DiffAnalyzer.Graph.Types exposing (..)
import Html exposing (Html, div, text)
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


view : GraphModel -> Html GraphMsg
view model =
  case model.currentFile of
    Nothing -> div [] [text "No file selected!"]
    Just file ->
      div []
          [ text <| "Selected file: " ++ file
          , chart model.deltas
          ]

chart : List Delta -> Html GraphMsg
chart deltas =
  let additions = List.map (\d -> (d.time, d.additions)) deltas
      deletions = List.map (\d -> (d.time, d.deletions)) deltas
  in LineChart.viewCustom chartConfig
     [ LineChart.line Colors.green Dots.circle "Additions" additions
     , LineChart.line Colors.red Dots.circle "Deletions" deletions
     ]

chartConfig : LineChart.Config (Float, Int) GraphMsg
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

