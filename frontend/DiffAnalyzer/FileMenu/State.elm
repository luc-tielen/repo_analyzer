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
            let
                updatedModel =
                    model |> setFiles files |> setMatchingFiles files
            in
                ( updatedModel, Nothing )

        FilesLoaded (Err err) ->
            ( model, Nothing )

        FileSelected file ->
            ( model |> setCurrentFile file, Just <| NotifyFileSelected file )

        FuzzyInputChanged input ->
            ( model |> setMatchingFiles (fuzzyMatchFiles input model.files), Nothing )


setFiles : List File -> FileMenuModel -> FileMenuModel
setFiles files model =
    { model | files = files }


setMatchingFiles : List File -> FileMenuModel -> FileMenuModel
setMatchingFiles matchingFiles model =
    { model | matchingFiles = matchingFiles }


setCurrentFile : File -> FileMenuModel -> FileMenuModel
setCurrentFile file model =
    { model | currentFile = Just file }


fuzzyMatchFiles : String -> List File -> List File
fuzzyMatchFiles =
    Fuzzy.filter identity
