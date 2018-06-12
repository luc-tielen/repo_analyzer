module DiffAnalyzer.Types exposing (..)

import DiffAnalyzer.FileMenu.Types exposing (..)
import DiffAnalyzer.Graph.Types exposing (..)

type alias Model =
  { fileMenu : FileMenuModel, graph : GraphModel }

type Msg = FileMenuMsg FileMenuMsg
         | GraphMsg GraphMsg
