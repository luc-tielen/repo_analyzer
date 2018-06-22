module DiffAnalyzer.Graph.State exposing (init, update)

import DiffAnalyzer.Graph.Types exposing (..)
import DiffAnalyzer.Graph.Rest exposing (..)
import DiffAnalyzer.Graph.Port exposing (drawChart)


init : GraphModel
init =
    { currentFile = Nothing, deltas = [], filterMode = NoFilter }


update : GraphMsg -> GraphModel -> ( GraphModel, Cmd GraphMsg )
update msg model =
    case msg of
        FileSelected file ->
            ( { model | currentFile = Just file }, getDeltasForFile file )

        DeltasRetrieved (Err _) ->
            ( model, Cmd.none )

        DeltasRetrieved (Ok deltas) ->
            model
                |> setDeltas deltas
                |> updateChart

        ChangeFilterMode mode ->
            model
                |> setFilterMode mode
                |> updateChart


setDeltas : List Delta -> GraphModel -> GraphModel
setDeltas deltas model =
    { model | deltas = deltas }


setFilterMode : FilterMode -> GraphModel -> GraphModel
setFilterMode mode model =
    { model | filterMode = mode }


updateChart : GraphModel -> ( GraphModel, Cmd GraphMsg )
updateChart model =
    let
        filteredDeltas =
            case model.filterMode of
                NoFilter ->
                    model.deltas

                OnlyChanges ->
                    List.filter isDeltaWithChanges model.deltas

        file =
            Maybe.withDefault "" model.currentFile
    in
        ( model, drawChart filteredDeltas )


isDeltaWithChanges : Delta -> Bool
isDeltaWithChanges d =
    d.additions /= 0 || d.deletions /= 0
