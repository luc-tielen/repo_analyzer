module DiffAnalyzer.Types exposing (..)

import DiffAnalyzer.FileMenu.Types as FileMenu

type alias Model = { fileMenu : FileMenu.Model }

type Msg = FileMenuMsg FileMenu.Msg
