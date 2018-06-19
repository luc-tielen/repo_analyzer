module DiffAnalyzer.Graph.Types exposing (..)

import Http


type alias File = String
type alias Author = String
type alias Commit = String
type alias Summary = String

type alias Delta =
  { author : Author
  , commit : Commit
  , summary : Summary
  , time : Float
  , additions : Int
  , deletions : Int
  }

type alias GraphModel = { currentFile: Maybe File, deltas : (List Delta) }

type GraphMsg = FileSelected File
              | DeltasRetrieved (Result Http.Error (List Delta))