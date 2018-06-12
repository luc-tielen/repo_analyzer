module DiffAnalyzer.FileMenu.Types exposing (..)

import Http


type alias File = String

type alias FileMenuModel =
  { files : List File, currentFile : Maybe File }

type FileMenuMsg = FilesLoaded (Result Http.Error (List File))
                 | FileSelected File

type FMUpstreamMsg = NotifyFileSelected File
