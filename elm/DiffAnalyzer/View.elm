module DiffAnalyzer.View exposing (view)

import DiffAnalyzer.Types exposing (..)
import DiffAnalyzer.FileMenu.View as FMView
import Html exposing (Html, div)


view : Model -> Html Msg
view model =
  div [] [FMView.view model.fileMenu |> Html.map FileMenuMsg]

