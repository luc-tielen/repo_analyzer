module DiffAnalyzer.Graph.State exposing (init, update)

import DiffAnalyzer.Graph.Types exposing (..)


init : GraphModel
init = { currentFile = Nothing }

update : GraphMsg -> GraphModel -> GraphModel
update msg model =
  case msg of
    FileSelected file -> { model | currentFile = Just file }
