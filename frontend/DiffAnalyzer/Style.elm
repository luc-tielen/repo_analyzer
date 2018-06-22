module DiffAnalyzer.Style exposing (..)

import Style exposing (..)
import Style.Scale as Scale
import Style.Font as Font
import Style.Border as Border
import Style.Color as Color
import Style.Shadow as Shadow
import Color exposing (Color, rgba)


type Styles
    = None
    | Button
    | TextInput
    | Text TextStyles
    | FileMenu
    | FileMenuItem FMItemStyles


type TextStyles
    = Title
    | Standard


type FMItemStyles
    = Normal
    | Selected


type alias FontScale =
    Int


styleSheet : Style.StyleSheet Styles variation
styleSheet =
    Style.styleSheet
        [ style None []
        , style Button
            [ Border.solid
            , Border.rounded 5
            , Color.background lightGray
            , Shadow.simple
            ]
        , style TextInput <|
            [ Shadow.simple
            , Border.solid
            , Border.rounded 5
            , Border.all 1
            , prop "border-color" "rgb(238, 238, 236)"
            ]
                ++ (font 1)
        , style (Text Title) <| Font.bold :: (font 2)
        , style (Text Standard) <| font 1
        , style FileMenu <|
            [ Border.solid
            , Border.right 1
            , prop "border-color" "rgb(238, 238, 236)"
            ]
        , style (FileMenuItem Normal) <|
            [ Border.solid
            , Border.bottom 1
            , prop "border-color" "rgb(238, 238, 236)"
            , hover [ Color.background lightGray ]
            , cursor "pointer"
            ]
        , style (FileMenuItem Selected) <|
            [ Color.background babyBlue
            , Border.solid
            , Border.bottom 1
            , prop "border-color" "rgb(238, 238, 236)"
            ]
        ]


scale : FontScale -> Float
scale =
    Scale.modular 14 1.618


font : FontScale -> List (Property class variation)
font size =
    [ Font.typeface
        [ Font.font "Roboto"
        , Font.sansSerif
        ]
    , Font.size <| scale size
    ]


babyBlue : Color
babyBlue =
    rgba 52 101 164 0.4


lightGray : Color
lightGray =
    rgba 238 238 236 1
