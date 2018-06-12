module DiffAnalyzer.Graph.State exposing (init, update)

import DiffAnalyzer.Graph.Types exposing (..)


init : Model
init = { currentFile = Nothing }

update : GraphMsg -> Model -> Model
update msg model =
  case msg of
    FileSelected file -> { model | currentFile = Just file }
