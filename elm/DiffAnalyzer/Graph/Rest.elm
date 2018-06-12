module DiffAnalyzer.Graph.Rest exposing (getDeltasForFile)

import DiffAnalyzer.Graph.Types exposing (..)
import Http
import Json.Decode as JD
import Json.Encode as JE


deltaDecoder : JD.Decoder Delta
deltaDecoder = JD.map6 Delta JD.string JD.string JD.string JD.int JD.int JD.int

getDeltasForFile : File -> Cmd GraphMsg
getDeltasForFile file =
  let url = "/api/v1/deltas"
      deltasDecoder = JD.list deltaDecoder |> JD.at ["deltas"]
      postBody = Http.jsonBody <| JE.object [("file", JE.string file)]
      req = Http.post url postBody deltasDecoder
  in Http.send DeltasRetrieved req
