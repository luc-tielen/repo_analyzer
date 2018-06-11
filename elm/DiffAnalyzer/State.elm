module DiffAnalyzer.State exposing (init, update, subscriptions)

import DiffAnalyzer.Types exposing (..)
import DiffAnalyzer.FileMenu.Rest as FMRest
import DiffAnalyzer.FileMenu.State as FMState


init : (Model, Cmd Msg)
init =
  let (fmModel, initialCmd) = FMState.init
  in ({ fileMenu = fmModel }, Cmd.map FileMenuMsg initialCmd)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FileMenuMsg msg ->
      let (updatedFMModel, fmCmd) = FMState.update msg model.fileMenu
      in ({ model | fileMenu = updatedFMModel }, Cmd.map FileMenuMsg fmCmd)

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
