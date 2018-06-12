module DiffAnalyzer.FileMenu.State exposing (init, update)

import DiffAnalyzer.FileMenu.Types exposing (..)
import DiffAnalyzer.FileMenu.Rest as FMRest


init : (FileMenuModel, Cmd FileMenuMsg)
init = ({ files = [], currentFile = Nothing }, FMRest.getFilesInRepo)

update : FileMenuMsg -> FileMenuModel -> (FileMenuModel, Maybe FMUpstreamMsg)
update msg model =
  case msg of
    FilesLoaded (Ok files) ->
      ({ model | files = files }, Nothing)
    FilesLoaded (Err err) ->
      (model, Nothing)
    FileSelected file ->
      ({ model | currentFile = Just file }, Just <| NotifyFileSelected file)

