module Main exposing (Model, Msg(..), init, main, update, view)

import Browser exposing (Document)
import Html exposing (Html, button, div, h1, h2, span, strong, text)
import Html.Attributes exposing (class)


type Msg
    = NoOp


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Ahorcado ◦ Elm!!"
    , body =
        [ div [ class "wrapper" ]
            [ h1 [] [ text "Adivina la palabra!!" ]
            ]
        ]
    }


main : Program () Model Msg
main =
    Browser.document
        { view = view
        , init = always init
        , update = update
        , subscriptions = always Sub.none
        }
