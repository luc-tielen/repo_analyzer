module DiffAnalyzer.State exposing (init, update, subscriptions)

import DiffAnalyzer.Types exposing (..)
import DiffAnalyzer.Rest as Rest


init : (Model, Cmd Msg)
init = ({ files = [], currentFile = Nothing }, Rest.getFilesInRepo)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FilesLoaded (Ok files) ->
      ({ model | files = files }, Cmd.none)
    FilesLoaded (Err err) ->
      (model, Cmd.none)
    FileSelected file ->
      ({ model | currentFile = Just file }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
