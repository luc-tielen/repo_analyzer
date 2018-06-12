module DiffAnalyzer.Graph.Types exposing (..)


type alias File = String

type alias Model = { currentFile: Maybe File }

type GraphMsg = FileSelected File
