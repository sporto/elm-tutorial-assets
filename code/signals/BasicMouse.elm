module Main (..) where

import Html exposing (Html)
import Mouse


view : Int -> Html
view x =
  Html.text (toString x)


main : Signal.Signal Html
main =
  Signal.map view Mouse.x
