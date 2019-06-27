module RosterTests exposing (addApprentice, init, sith)

import Array
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Roster exposing (Roster, Sith)
import Test exposing (..)


sith : Sith
sith =
    { name = "Darth Rafał"
    , homeworld = "Kazimierz"
    , apprenticeId = Nothing
    , masterId = Nothing
    }


init : Test
init =
    describe "init"
        [ test "initializes empty roster and adds sith in the middle of the roster" <|
            \_ ->
                Roster.init sith
                    |> Array.get 2
                    |> Maybe.withDefault Nothing
                    |> Expect.equal (Just sith)
        ]


addApprentice : Test
addApprentice =
    describe "addApprentice"
        [ test "when the Roster is empty adds apprentice in the middle of the roster" <|
            \_ ->
                Roster.addApprentice sith Roster.empty
                    |> Expect.equal (Roster.init sith)
        , test "when the Roster is partially full adds apprentice in the first free row after last sith" <|
            \_ ->
                Roster.addApprentice sith (Roster.init sith)
                    |> Expect.equal (Array.fromList [ Nothing, Nothing, Just sith, Just sith, Nothing ])
        , todo "when the Roster's last row is occupied does nothing"
        ]
