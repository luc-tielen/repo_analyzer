module DiffAnalyzer.FileMenu.View exposing (view)

import DiffAnalyzer.FileMenu.Types exposing (..)
import Html exposing (Html, text, ul, li)
import Html.Events exposing (onClick)


view : FileMenuModel -> Html FileMenuMsg
view model =
  let {files} = model
      showFile file = li [onClick <| FileSelected file] [text file]
  in ul [] <| List.map showFile files
