module DiffAnalyzer.FileMenu.State exposing (init, update)

import DiffAnalyzer.FileMenu.Types exposing (..)
import DiffAnalyzer.FileMenu.Rest as FMRest


init : (Model, Cmd Msg)
init = ({ files = [], currentFile = Nothing }, FMRest.getFilesInRepo)

update : Msg -> Model -> (Model, UpstreamMsg)
update msg model =
  case msg of
    FilesLoaded (Ok files) ->
      ({ model | files = files }, NoEffect)
    FilesLoaded (Err err) ->
      (model, NoEffect)
    FileSelected file ->
      ({ model | currentFile = Just file }, NotifyFileSelected file)

