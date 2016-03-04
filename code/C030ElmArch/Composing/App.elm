module Main (..) where

import Html exposing (Html)
import StartApp.Simple
import C030ElmArch.Composing.Widget as Widget


-- MODEL


type alias AppModel =
  { widgetModel : Widget.Model
  }


initialModel : AppModel
initialModel =
  { widgetModel = Widget.initialModel
  }


type Action
  = WidgetAction Widget.Action



-- VIEW


view : Signal.Address Action -> AppModel -> Html
view address model =
  Html.div
    []
    [ Widget.view (Signal.forwardTo address WidgetAction) model.widgetModel
    ]



-- UPDATE


update : Action -> AppModel -> AppModel
update action model =
  case action of
    WidgetAction subAction ->
      let
        updatedWidgetModel =
          Widget.update subAction model.widgetModel
      in
        { model | widgetModel = updatedWidgetModel }



-- START APP


main : Signal.Signal Html
main =
  StartApp.Simple.start
    { model = initialModel
    , view = view
    , update = update
    }
