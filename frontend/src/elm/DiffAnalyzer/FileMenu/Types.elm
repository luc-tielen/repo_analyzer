module DiffAnalyzer.FileMenu.Types exposing (..)

import Http


type alias File =
    String


type alias FileMenuModel =
    { files : List File
    , matchingFiles : List File
    , currentFile : Maybe File
    }


type FileMenuMsg
    = FilesLoaded (Result Http.Error (List File))
    | FileSelected File
    | FuzzyInputChanged String


type FMUpstreamMsg
    = NotifyFileSelected File
