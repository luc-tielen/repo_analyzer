module DiffAnalyzer.Types exposing (..)

import DiffAnalyzer.FileMenu.Types as FileMenu
import DiffAnalyzer.Graph.Types as Graph

type alias Model = { fileMenu : FileMenu.Model, graph : Graph.Model }

type Msg = FileMenuMsg FileMenu.Msg
         | GraphMsg Graph.GraphMsg
