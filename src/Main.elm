module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http


main =
    Browser.element
        { init = init
        , subscriptions = \_ -> Sub.none
        , view = view
        , update = update
        }


type alias Model =
    Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( 0
    , Http.get
        { url = "http://localhost:3000/dark-jedis/3616"
        , expect = Http.expectString GotText
        }
    )


type Msg
    = GotText (Result Http.Error String)


update : msg -> Model -> ( Model, Cmd msg )
update msg model =
    ( model, Cmd.none )


viewSith name planet =
    li [ class "css-slot" ]
        [ h3 []
            [ text name ]
        , h6 []
            [ text <| "Homeworld: " ++ planet ]
        ]


view : Model -> Html msg
view _ =
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
                ]
            , div [ class "css-scroll-buttons" ]
                [ button [ class "css-button-up" ]
                    []
                , button [ class "css-button-down" ]
                    []
                ]
            ]
        ]
