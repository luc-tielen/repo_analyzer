module DiffAnalyzer.Chart.Types exposing (..)

import Http


type alias File =
    String


type alias Author =
    String


type alias Commit =
    String


type alias Summary =
    String


type alias Delta =
    { author : Author
    , commit : Commit
    , summary : Summary
    , time : Float
    , additions : Int
    , deletions : Int
    }


type FilterMode
    = NoFilter
    | OnlyChanges


type alias ChartModel =
    { apiUrl : String
    , currentFile : Maybe File
    , deltas : List Delta
    , filterMode : FilterMode
    }


type ChartMsg
    = FileSelected File
    | DeltasRetrieved (Result Http.Error (List Delta))
    | ChangeFilterMode FilterMode
