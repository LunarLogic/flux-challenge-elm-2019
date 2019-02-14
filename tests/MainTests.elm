module MainTests exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Main exposing (Msg(..), init, update)
import Test exposing (..)


suite : Test
suite =
    describe "update function"
        [ test "doesn't send a request when sith has no apprentice" <|
            \_ ->
                let
                    sith =
                        { name = ""
                        , homeworld = ""
                        , apprenticeId = Nothing
                        }

                    msg =
                        GotSith (Ok sith)

                    model =
                        init () |> Tuple.first
                in
                update msg model
                    |> Tuple.second
                    |> (==) Cmd.none
                    |> Expect.true "Expected the command to be Cmd.none"
        ]
