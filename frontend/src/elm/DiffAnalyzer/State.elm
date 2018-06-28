module DiffAnalyzer.State exposing (init, update, subscriptions)

import DiffAnalyzer.Types exposing (..)
import DiffAnalyzer.FileMenu.Types exposing (FileMenuModel, FMUpstreamMsg(..))
import DiffAnalyzer.Chart.Types exposing (ChartModel, ChartMsg(FileSelected))
import DiffAnalyzer.FileMenu.State as FMState
import DiffAnalyzer.Chart.State as CState


init : Config -> ( Model, Cmd Msg )
init cfg =
    let
        apiUrl =
            cfg.apiUrl

        ( fmModel, initialCmd ) =
            FMState.init apiUrl

        cModel =
            CState.init apiUrl
    in
        ( { fileMenu = fmModel, chart = cModel, config = cfg }, Cmd.map FileMenuMsg initialCmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FileMenuMsg msg ->
            let
                ( updatedFMModel, upstream ) =
                    FMState.update msg model.fileMenu

                updatedModel =
                    model |> updateFMModel updatedFMModel
            in
                Maybe.map (flip forwardFileUpdate updatedModel) upstream
                    |> Maybe.withDefault ( updatedModel, Cmd.none )

        ChartMsg msg ->
            let
                ( updatedCModel, cCmd ) =
                    CState.update msg model.chart
            in
                ( model |> updateChartModel updatedCModel, Cmd.map ChartMsg cCmd )


updateFMModel : FileMenuModel -> Model -> Model
updateFMModel fmModel model =
    { model | fileMenu = fmModel }


updateChartModel : ChartModel -> Model -> Model
updateChartModel cModel model =
    { model | chart = cModel }


forwardFileUpdate : FMUpstreamMsg -> Model -> ( Model, Cmd Msg )
forwardFileUpdate (NotifyFileSelected file) model =
    let
        ( updatedChart, chartCmd ) =
            CState.update (FileSelected file) model.chart

        updatedModel =
            model |> updateChartModel updatedChart
    in
        ( updatedModel, Cmd.map ChartMsg chartCmd )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
