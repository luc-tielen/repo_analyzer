module DiffAnalyzer.Graph.View exposing (view)

import DiffAnalyzer.Graph.Types exposing (..)
import Html exposing (Html, div, text)


view : Model -> Html GraphMsg
view model =
  case model.currentFile of
    Nothing -> div [] [text "No file selected!"]
    Just file -> div [] [text <| "Selected file: " ++ file]
