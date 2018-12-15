module Palabra exposing (Palabra, decoder, palabra)

import Http
import Json.Decode as Decode exposing (Decoder, field, map)


type alias Palabra =
    { palabra : String
    }


palabra : Palabra -> String
palabra =
    .palabra


decoder : Decoder Palabra
decoder =
    map Palabra
        (field "palabra" Decode.string)
