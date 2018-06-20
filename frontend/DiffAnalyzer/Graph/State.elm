module DiffAnalyzer.Graph.State exposing (init, update)

import DiffAnalyzer.Graph.Types exposing (..)
import DiffAnalyzer.Graph.Rest exposing (..)


init : GraphModel
init =
  { currentFile = Nothing, deltas = [], filterMode = NoFilter }

update : GraphMsg -> GraphModel -> (GraphModel, Cmd GraphMsg)
update msg model =
  case msg of
    FileSelected file ->
      ({ model | currentFile = Just file }, getDeltasForFile file)
    DeltasRetrieved (Err _) ->
      (model, Cmd.none)
    DeltasRetrieved (Ok deltas) ->
      ({ model | deltas = deltas }, Cmd.none)
    ChangeFilterMode mode ->
      ({ model | filterMode = mode }, Cmd.none)

