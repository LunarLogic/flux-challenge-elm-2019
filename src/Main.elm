module Main exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)


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
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Array.empty
    , Http.get
        { url = "http://localhost:3000/dark-jedis/3616"
        , expect = Http.expectJson GotSith sithDecoder
        }
    )


sithDecoder : Decoder Sith
sithDecoder =
    Json.Decode.map2 Sith
        (field "name" string)
        (field "homeworld" (field "name" string))


type Msg
    = GotSith (Result Http.Error Sith)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotSith (Ok sith) ->
            ( Array.push sith model, Cmd.none )

        GotSith _ ->
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
