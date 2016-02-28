module Main (..) where

import Html exposing (Html)
import Mouse


type alias Model =
  { count : Int
  }


initialModel : Model
initialModel =
  { count = 0
  }


view : Model -> Html
view model =
  Html.text (toString model.count)


modelSignal : Signal.Signal Model
modelSignal =
  Signal.foldp (\_ state -> { state | count = state.count + 1 }) initialModel Mouse.clicks


main : Signal.Signal Html
main =
  Signal.map view modelSignal
