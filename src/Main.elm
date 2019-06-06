module Main exposing (Msg(..), init, main, update)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, field, int, nullable, string)


main =
    Browser.element
        { init = init
        , subscriptions = \_ -> Sub.none
        , view = view
        , update = update
        }


type alias Model =
    Array Sith


type alias Sith =
    { name : String
    , homeworld : String
    , apprenticeId : Maybe Int
    , masterId : Maybe Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Array.empty
    , Http.get
        { url = "http://localhost:3000/dark-jedis/3616"
        , expect = Http.expectJson GotApprentice sithDecoder
        }
    )


sithDecoder : Decoder Sith
sithDecoder =
    Json.Decode.map4 Sith
        (field "name" string)
        (field "homeworld" (field "name" string))
        (field "apprentice" (field "id" (nullable int)))
        (field "master" (field "id" (nullable int)))


type Msg
    = GotApprentice (Result Http.Error Sith)
    | GotMaster (Result Http.Error Sith)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotApprentice (Ok sith) ->
            ( Array.push sith model
            , case sith.apprenticeId of
                Nothing ->
                    Array.get 0 model
                        |> Maybe.andThen .masterId
                        |> Maybe.map
                            (\masterId ->
                                Http.get
                                    { url = "http://localhost:3000/dark-jedis/" ++ String.fromInt masterId
                                    , expect = Http.expectJson GotMaster sithDecoder
                                    }
                            )
                        |> Maybe.withDefault Cmd.none

                Just apprenticeId ->
                    Http.get
                        { url = "http://localhost:3000/dark-jedis/" ++ String.fromInt apprenticeId
                        , expect = Http.expectJson GotApprentice sithDecoder
                        }
            )

        GotMaster (Ok sith) ->
            let
                newModel =
                    Array.append (Array.fromList [ sith ]) model
            in
            ( newModel
            , if Array.length newModel < 5 then
                case sith.masterId of
                    Nothing ->
                        Cmd.none

                    Just masterId ->
                        Http.get
                            { url = "http://localhost:3000/dark-jedis/" ++ String.fromInt masterId
                            , expect = Http.expectJson GotMaster sithDecoder
                            }

              else
                Cmd.none
            )

        GotMaster _ ->
            ( model, Cmd.none )

        GotApprentice _ ->
            ( model, Cmd.none )


viewSith : Sith -> Html msg
viewSith sith =
    li [ class "css-slot" ]
        [ h3 []
            [ text sith.name ]
        , h6 []
            [ text <| "Homeworld: " ++ sith.homeworld ]
        ]


view : Model -> Html msg
view model =
    div [ class "css-root" ]
        [ h1 [ class "css-planet-monitor" ]
            [ text "Obi-Wan currently on Tatooine" ]
        , section [ class "css-scrollable-list" ]
            [ ul [ class "css-slots" ] (Array.map viewSith model |> Array.toList)
            , div [ class "css-scroll-buttons" ]
                [ button [ class "css-button-up" ]
                    []
                , button [ class "css-button-down" ]
                    []
                ]
            ]
        ]
