module Main (..) where

import Html exposing (Html)
import Time
import Debug
import Task exposing (Task)


view : Time.Time -> Html
view time =
  Html.text (toString time)


mb : Signal.Mailbox Time.Time
mb =
  Signal.mailbox 0.0


sendToMailbox : Time.Time -> Time.Time
sendToMailbox time =
  let
    _ =
      Debug.log "Sending" time
  in
    Signal.send mb.address time
      |> always time


countSignal : Signal Time.Time
countSignal =
  Signal.map sendToMailbox (Time.every Time.second)


main : Signal Html
main =
  Signal.map view countSignal


mailboxListener =
  Signal.map (Debug.log "from mailbox") mb.signal


port runner : Signal Time.Time
port runner =
  mb.signal
