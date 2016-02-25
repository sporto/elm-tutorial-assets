module Main (..) where

import Html exposing (Html)
import Mouse


view : Int -> Html
view count =
  Html.text (toString count)


countSignal : Signal Int
countSignal =
  Signal.foldp (\_ state -> state + 1) 0 Mouse.clicks


main : Signal.Signal Html
main =
  Signal.map view countSignal
