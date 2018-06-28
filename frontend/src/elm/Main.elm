module Main exposing (main)

import DiffAnalyzer.State as State
import DiffAnalyzer.View as View
import DiffAnalyzer.Types exposing (Config, Model, Msg)
import Html


main : Program Config Model Msg
main =
    Html.programWithFlags
        { init = State.init
        , update = State.update
        , view = View.view
        , subscriptions = State.subscriptions
        }
