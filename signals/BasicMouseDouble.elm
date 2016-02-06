module Main (..) where

import Html
import Mouse


double x =
    x * 2


doubleSignal =
    Signal.map double Mouse.x


view : Int -> Html.Html
view x =
    Html.text (toString x)


main : Signal.Signal Html.Html
main =
    Signal.map view doubleSignal
