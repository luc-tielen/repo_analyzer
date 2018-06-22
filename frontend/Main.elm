module Main exposing (main)

import DiffAnalyzer.State as State
import DiffAnalyzer.View as View
import DiffAnalyzer.Types exposing (Model, Msg)
import Html


main : Program Never Model Msg
main =
    Html.program
        { init = State.init
        , update = State.update
        , view = View.view
        , subscriptions = State.subscriptions
        }
