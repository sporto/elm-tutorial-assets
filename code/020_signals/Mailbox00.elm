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


sendToMailbox : Time.Time -> (Task a ())
sendToMailbox time =
  let
    _ =
      Debug.log "Sending" time
  in
    Signal.send mb.address time

signalTask : Signal (Task a ())
signalTask =
  Signal.map sendToMailbox (Time.every Time.second)


main : Signal Html
main =
  Signal.map view mailboxListener


mailboxListener =
  Signal.map (Debug.log "from mailbox") mb.signal


port runner : Signal (Task a ())
port runner =
  signalTask
