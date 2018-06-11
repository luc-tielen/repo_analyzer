module DiffAnalyzer.Rest exposing (getFilesInRepo)

import DiffAnalyzer.Types exposing (Msg(FilesLoaded))
import Http
import Json.Decode as JD


getFilesInRepo : Cmd Msg
getFilesInRepo =
  let url = "/api/v1/files_in_repo"
      filesDecoder = JD.list JD.string |> JD.at ["files"]
      req = Http.get url filesDecoder
  in Http.send FilesLoaded req

