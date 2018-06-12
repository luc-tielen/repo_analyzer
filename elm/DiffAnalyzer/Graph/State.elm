module DiffAnalyzer.Graph.State exposing (init, update)

import DiffAnalyzer.Graph.Types exposing (..)
import DiffAnalyzer.Graph.Rest exposing (..)


init : GraphModel
init = { currentFile = Nothing }

update : GraphMsg -> GraphModel -> (GraphModel, Cmd GraphMsg)
update msg model =
  case msg of
    FileSelected file ->
      ({ model | currentFile = Just file }, getDeltasForFile file)
    DeltasRetrieved deltas ->
      (model, Cmd.none)
