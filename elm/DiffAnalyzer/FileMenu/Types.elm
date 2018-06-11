module DiffAnalyzer.FileMenu.Types exposing (..)

import Http


type alias File = String

type alias Model = { files : List File, currentFile : Maybe File }

type Msg = FilesLoaded (Result Http.Error (List File))
         | FileSelected File
