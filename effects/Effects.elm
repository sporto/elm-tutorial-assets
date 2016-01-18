import Html
import Html.Events as Events
import Http
import Task
import Debug
import Effects

type Action =
  NoOp |
  Refresh |
  OnRefresh (Result Http.Error String)

type alias Model = String

view : Signal.Address Action -> Model -> Html.Html
view address message =  
  Html.div [] [
    Html.button [
      Events.onClick address Refresh
    ]
    [
      Html.text "Refresh"
    ],
    Html.text message
  ]

actionsMailbox : Signal.Mailbox (List Action)
actionsMailbox =
  Signal.mailbox []

oneActionAddress : Signal.Address Action
oneActionAddress =
  Signal.forwardTo actionsMailbox.address (\action -> [action])

httpTask : Task.Task Http.Error String
httpTask =
  Http.getString "http://localhost:3000/"

refreshFx : Effects.Effects Action
refreshFx =
  httpTask
    |> Task.toResult
    |> Task.map OnRefresh
    |> Effects.task

update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case Debug.log "action" action of
    Refresh ->
      (model, refreshFx)
    OnRefresh result ->
      let
        message =
          Result.withDefault "" result
      in
        (message, Effects.none)
    _ ->
      (model, Effects.none)

modelAndFxSignal : Signal.Signal (Model, Effects.Effects Action)
modelAndFxSignal =
  let
    modelAndFx action (previousModel, _) =
      update action previousModel
    modelAndManyFxs actions (previousModel, _) =
      List.foldl modelAndFx (previousModel, Effects.none) actions
    initial =
      ("-", Effects.none)
  in
    Signal.foldp modelAndManyFxs initial actionsMailbox.signal

modelSignal : Signal.Signal Model
modelSignal =
  Signal.map fst modelAndFxSignal

fxSignal : Signal.Signal (Effects.Effects Action)
fxSignal =
  Signal.map snd modelAndFxSignal

taskSignal : Signal (Task.Task Effects.Never ())
taskSignal =
  Signal.map (Effects.toTask actionsMailbox.address) fxSignal

main: Signal.Signal Html.Html
main =
  Signal.map (view oneActionAddress) modelSignal

port runner : Signal (Task.Task Effects.Never ())
port runner =
  taskSignal
