module DiffAnalyzer.Chart.State exposing (init, update)

import DiffAnalyzer.Chart.Types exposing (..)
import DiffAnalyzer.Chart.Rest exposing (..)
import DiffAnalyzer.Chart.Port exposing (drawChart)


init : String -> ChartModel
init apiUrl =
    { apiUrl = apiUrl, currentFile = Nothing, deltas = [], filterMode = NoFilter }


update : ChartMsg -> ChartModel -> ( ChartModel, Cmd ChartMsg )
update msg model =
    case msg of
        FileSelected file ->
            ( { model | currentFile = Just file }, getDeltasForFile model.apiUrl file )

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


setDeltas : List Delta -> ChartModel -> ChartModel
setDeltas deltas model =
    { model | deltas = deltas }


setFilterMode : FilterMode -> ChartModel -> ChartModel
setFilterMode mode model =
    { model | filterMode = mode }


updateChart : ChartModel -> ( ChartModel, Cmd ChartMsg )
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
