module Main exposing (main)

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
    String


init : () -> ( Model, Cmd Msg )
init _ =
    ( ""
    , Http.get
        { url = "http://localhost:3000/dark-jedis/3616"
        , expect = Http.expectJson GotText nameDecoder
        }
    )


nameDecoder : Decoder String
nameDecoder =
    field "name" string


type Msg
    = GotText (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText (Ok string) ->
            ( string, Cmd.none )

        GotText _ ->
            ( model, Cmd.none )


viewSith name planet =
    li [ class "css-slot" ]
        [ h3 []
            [ text name ]
        , h6 []
            [ text <| "Homeworld: " ++ planet ]
        ]


view : Model -> Html msg
view model =
    div [ class "css-root" ]
        [ h1 [ class "css-planet-monitor" ]
            [ text "Obi-Wan currently on Tatooine" ]
        , section [ class "css-scrollable-list" ]
            [ ul [ class "css-slots" ]
                [ viewSith "Jorak Uln" "Korriban"
                , viewSith "Skere Kaan" "Coruscant"
                , viewSith "Na'daz" "Ryloth"
                , viewSith "Kas'im" "Nal Hutta"
                , viewSith "Darth Bane" "Apatros"
                , viewSith model "Kraków"
                ]
            , div [ class "css-scroll-buttons" ]
                [ button [ class "css-button-up" ]
                    []
                , button [ class "css-button-down" ]
                    []
                ]
            ]
        ]
