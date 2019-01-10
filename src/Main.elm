module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


viewSith name planet =
    li [ class "css-slot" ]
        [ h3 []
            [ text name ]
        , h6 []
            [ text <| "Homeworld: " ++ planet ]
        ]


main =
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
