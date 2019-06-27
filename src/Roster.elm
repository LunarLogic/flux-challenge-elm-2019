module Roster exposing (Roster, Sith, addApprentice, empty, init)

import Array exposing (Array)


type alias Sith =
    { name : String
    , homeworld : String
    , apprenticeId : Maybe Int
    , masterId : Maybe Int
    }


type alias Roster =
    Array (Maybe Sith)


init : Sith -> Roster
init sith =
    Array.fromList [ Nothing, Nothing, Just sith, Nothing, Nothing ]


empty : Roster
empty =
    Array.repeat 5 Nothing


isEmpty : Roster -> Bool
isEmpty roster =
    roster == empty


addApprentice : Sith -> Roster -> Roster
addApprentice sith roster =
    if isEmpty roster then
        init sith
    else
        case Array.toList roster of
            [ _, _, _, _, Just _ ] ->
                roster

            [ _, _, _, Just _, Nothing ] ->
                Array.set 4 (Just sith) roster

            [ _, _, Just _, Nothing, Nothing ] ->
                Array.set 3 (Just sith) roster

            [ _, Just _, Nothing, Nothing, Nothing ] ->
                Array.set 2 (Just sith) roster

            [ Just _, Nothing, Nothing, Nothing, Nothing ] ->
                Array.set 1 (Just sith) roster

            _ ->
                roster
