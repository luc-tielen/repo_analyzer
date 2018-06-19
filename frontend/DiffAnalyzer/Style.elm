module DiffAnalyzer.Style exposing (..)

import Style exposing (..)

type Styles = None

styleSheet : Style.StyleSheet Styles variation
styleSheet =
  Style.styleSheet
    [ style None []
    ]
