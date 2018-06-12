module DiffAnalyzer.Graph.Types exposing (..)


type alias File = String

type alias GraphModel = { currentFile: Maybe File }

type GraphMsg = FileSelected File
