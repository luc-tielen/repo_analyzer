module DiffAnalyzer.FileMenu.View exposing (view)

import DiffAnalyzer.FileMenu.Types exposing (..)
import DiffAnalyzer.Style exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)


view : FileMenuModel -> Element Styles variation FileMenuMsg
view model =
  let {files, currentFile} = model
      listItems = List.map (showFile currentFile) files
      title = el (Text Title) [ center ] <| text "Files in repository"
      columnContents = title :: listItems
  in column FileMenu
     [ width (px 300), height (percent 100), scrollbars
     , paddingLeft 10, paddingTop 10, paddingBottom 10, spacing 3 ]
     columnContents


showFile : Maybe File -> File -> Element Styles variation FileMenuMsg
showFile selectedFile file =
  let style = case (selectedFile, file) of
        (Nothing, _) -> FileMenuItem Normal
        (Just f1, f2) -> FileMenuItem (if f1 == f2 then Selected else Normal)
  in el style [onClick <| FileSelected file] <|
      el (Text Standard) [] <| text <| truncateFile file

{-| Helper function that truncates the start of a file name. -}
truncateFile : File -> String
truncateFile file =
  let maxChars = 30
      numFileChars = String.length file
      charsToRemove = numFileChars - maxChars - 3
  in if charsToRemove <= 0
        then file
        else "..." ++ (String.dropLeft charsToRemove file)

