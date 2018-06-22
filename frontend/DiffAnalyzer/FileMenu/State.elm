module DiffAnalyzer.FileMenu.State exposing (init, update)

import DiffAnalyzer.FileMenu.Types exposing (..)
import DiffAnalyzer.FileMenu.Rest as FMRest
import Simple.Fuzzy as Fuzzy


init : ( FileMenuModel, Cmd FileMenuMsg )
init =
    let
        initialModel =
            { files = [], matchingFiles = [], currentFile = Nothing }

        initialCmd =
            FMRest.getFilesInRepo
    in
        ( initialModel, initialCmd )


update : FileMenuMsg -> FileMenuModel -> ( FileMenuModel, Maybe FMUpstreamMsg )
update msg model =
    case msg of
        FilesLoaded (Ok files) ->
            ( { model | files = files, matchingFiles = files }, Nothing )

        FilesLoaded (Err err) ->
            ( model, Nothing )

        FileSelected file ->
            ( { model | currentFile = Just file }, Just <| NotifyFileSelected file )

        FuzzyInputChanged input ->
            ( { model | matchingFiles = fuzzyMatchFiles input model.files }, Nothing )


fuzzyMatchFiles : String -> List File -> List File
fuzzyMatchFiles =
    Fuzzy.filter (\x -> x)
