module DiffAnalyzer.FileMenu.View exposing (view)

import DiffAnalyzer.FileMenu.Types exposing (..)
import Html exposing (Html, text, ul, li)


view : Model -> Html Msg
view model =
  let {files} = model
      showFile file = li [] [text file]
  in ul [] <| List.map showFile files
