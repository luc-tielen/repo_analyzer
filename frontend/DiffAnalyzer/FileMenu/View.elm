module DiffAnalyzer.FileMenu.View exposing (view)

import DiffAnalyzer.FileMenu.Types exposing (..)
import DiffAnalyzer.Style exposing (..)
import Element exposing (..)
import Element.Events exposing (onClick)


view : FileMenuModel -> Element Styles variation FileMenuMsg
view model =
  let {files} = model
      showFile file = el None [onClick <| FileSelected file] <| text file
  in column None [] <| List.map showFile files
