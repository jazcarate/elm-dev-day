module Main exposing (Model, Msg(..), init, main, update, view)

import Ahorcado exposing (Ahorcado)
import Array exposing (Array)
import Browser exposing (Document)
import Browser.Events
import Html exposing (Html, button, div, h1, h2, span, strong, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import List.Selection exposing (Selection)
import Palabra exposing (Palabra)


type Msg
    = GotPalabra (Result Http.Error Palabra)
    | Intentar (Maybe Char)
    | Reset


type alias Model =
    { ahorcado : ModeloAhorcado
    }


type ModeloAhorcado
    = Fallo Http.Error
    | Loading
    | Funciono Ahorcado


initAhorcado : ModeloAhorcado
initAhorcado =
    Loading


backendGet : Cmd Msg
backendGet =
    Http.get
        { url = "/backend/"
        , expect = Http.expectJson GotPalabra Palabra.decoder
        }


init : ( Model, Cmd Msg )
init =
    ( { ahorcado = initAhorcado }
    , backendGet
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotPalabra result ->
            case result of
                Ok palabra ->
                    ( { model | ahorcado = Funciono <| Ahorcado.init <| Palabra.palabra palabra }, Cmd.none )

                Err err ->
                    ( { model | ahorcado = Fallo err }, Cmd.none )

        Intentar char ->
            let
                nuevoModelo modelo =
                    Maybe.withDefault modelo <|
                        Maybe.map
                            (\c -> { modelo | ahorcado = modeloAhorcadoMap modelo.ahorcado (always modelo.ahorcado) (Funciono << Ahorcado.intentar c) modelo.ahorcado })
                            char
            in
            ( nuevoModelo model, Cmd.none )

        Reset ->
            init


view : Model -> Document Msg
view model =
    { title = "Ahorcado ◦ Elm!!"
    , body =
        [ div [ class "wrapper" ]
            [ h1 [] [ text "Adivina la palabra!!" ]
            , button [ onClick Reset ] [ text "reset" ]
            , mostrarModeloAhorcado model.ahorcado
            ]
        ]
    }


mostrarModeloAhorcado : ModeloAhorcado -> Html Msg
mostrarModeloAhorcado ma =
    modeloAhorcadoMap
        (h1 [] [ text "Cargando" ])
        (always (h1 [] [ text "Algo falló" ]))
        mostrarAhorcado
        ma


modeloAhorcadoMap : a -> (Http.Error -> a) -> (Ahorcado -> a) -> ModeloAhorcado -> a
modeloAhorcadoMap cargando fallo funciono ma =
    case ma of
        Fallo err ->
            fallo err

        Funciono success ->
            funciono success

        Loading ->
            cargando


mostrarAhorcado : Ahorcado -> Html a
mostrarAhorcado ahorcado =
    div []
        [ mostrarGanador ahorcado
        , h2 [] [ text <| Ahorcado.mostrar ahorcado ]
        , div [ class "intentos" ] <| List.map (\c -> span [ class "intento" ] [ text <| String.fromChar c ]) (Ahorcado.getIntentos ahorcado)
        ]


mostrarGanador ahorcado =
    if Ahorcado.gano ahorcado then
        h1 [ class "winner" ] [ text "YOU'RE WINNER !" ]

    else
        span [] []


main : Program () Model Msg
main =
    Browser.document
        { view = view
        , init = always init
        , update = update
        , subscriptions = always <| Browser.Events.onKeyPress <| Decode.map Intentar letraDecoder
        }


letraDecoder : Decode.Decoder (Maybe Char)
letraDecoder =
    Decode.map primeraLeta (Decode.field "key" Decode.string)


primeraLeta : String -> Maybe Char
primeraLeta string =
    case String.uncons string of
        Just ( char, "" ) ->
            Just char

        _ ->
            Nothing
