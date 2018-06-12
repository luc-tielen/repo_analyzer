module DiffAnalyzer.FileMenu.Rest exposing (getFilesInRepo)

import DiffAnalyzer.FileMenu.Types exposing (..)
import Http
import Json.Decode as JD


getFilesInRepo : Cmd FileMenuMsg
getFilesInRepo =
  let url = "/api/v1/files_in_repo"
      filesDecoder = JD.list JD.string |> JD.at ["files"]
      req = Http.get url filesDecoder
  in Http.send FilesLoaded req
