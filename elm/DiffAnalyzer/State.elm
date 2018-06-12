module DiffAnalyzer.State exposing (init, update, subscriptions)

import DiffAnalyzer.Types exposing (..)
import DiffAnalyzer.FileMenu.Types exposing (FMUpstreamMsg(..))
import DiffAnalyzer.Graph.Types exposing (GraphMsg(FileSelected))
import DiffAnalyzer.FileMenu.State as FMState
import DiffAnalyzer.Graph.State as GState


init : (Model, Cmd Msg)
init =
  let (fmModel, initialCmd) = FMState.init
      gModel = GState.init
  in ({ fileMenu = fmModel, graph = gModel }, Cmd.map FileMenuMsg initialCmd)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    FileMenuMsg msg ->
      let (updatedFMModel, upstream) = FMState.update msg model.fileMenu
          updatedModel = { model | fileMenu = updatedFMModel }
      in case upstream of
        Nothing ->
          (updatedModel, Cmd.none)
        Just (NotifyFileSelected file) ->
          let updatedGModel = GState.update (FileSelected file) model.graph
              updatedModel2 = { updatedModel | graph = updatedGModel }
          in (updatedModel2, Cmd.none)
    GraphMsg msg ->
      (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none
