module DiffAnalyzer.Graph.Types exposing (..)

import Http


type alias File = String

type alias GraphModel = { currentFile: Maybe File }

type alias Delta =
  { author : String
  , commit : String
  , summary : String
  , time : Int
  , additions : Int
  , deletions : Int
  }

type GraphMsg = FileSelected File
              | DeltasRetrieved (Result Http.Error (List Delta))
