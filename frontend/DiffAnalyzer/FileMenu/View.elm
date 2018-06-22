module DiffAnalyzer.FileMenu.View exposing (view)

import DiffAnalyzer.Style exposing (..)
import DiffAnalyzer.FileMenu.Types exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Element.Input as Input


view : FileMenuModel -> Element Styles variation FileMenuMsg
view model =
    let
        { matchingFiles, currentFile } =
            model

        listItems =
            List.map (showFile currentFile) matchingFiles

        title =
            el (Text Title) [ center ] <| text "Files in repository"

        columnContents =
            title :: fuzzyFinder :: listItems
    in
        column FileMenu
            [ width (px 300)
            , height (percent 100)
            , scrollbars
            , paddingLeft 10
            , paddingTop 10
            , paddingBottom 10
            , spacing 3
            ]
            columnContents


fuzzyFinder : Element Styles variation FileMenuMsg
fuzzyFinder =
    let
        ffText =
            "Fuzzy finder"

        searchParams =
            { onChange = FuzzyInputChanged
            , label = Input.placeholder { text = ffText, label = Input.hiddenLabel ffText }
            , value = ""
            , options = []
            }
    in
        el None [ padding 10 ] <|
            Input.search TextInput
                [ paddingLeft 10, paddingRight 10, paddingTop 3, paddingBottom 3 ]
                searchParams


showFile : Maybe File -> File -> Element Styles variation FileMenuMsg
showFile selectedFile file =
    let
        style =
            case ( selectedFile, file ) of
                ( Nothing, _ ) ->
                    FileMenuItem Normal

                ( Just f1, f2 ) ->
                    FileMenuItem
                        (if f1 == f2 then
                            Selected
                         else
                            Normal
                        )
    in
        el style [ onClick <| FileSelected file ] <|
            el (Text Standard) [] <|
                text <|
                    truncateFile file


{-| Helper function that truncates the start of a file name.
-}
truncateFile : File -> String
truncateFile file =
    let
        maxChars =
            30

        numFileChars =
            String.length file

        charsToRemove =
            numFileChars - maxChars - 3
    in
        if charsToRemove <= 0 then
            file
        else
            "..." ++ (String.dropLeft charsToRemove file)
