module Ahorcado exposing (Ahorcado(..), gano, getIntentos, init, intentar, mostrar)


type Ahorcado
    = Ahorcado (List Char) String


init : String -> Ahorcado
init palabra =
    Ahorcado [] palabra


gano : Ahorcado -> Bool
gano (Ahorcado intentos palabra) =
    String.toList palabra
        |> List.all (fueAdivinado intentos)


intentar : Char -> Ahorcado -> Ahorcado
intentar c ((Ahorcado intentos palabra) as ahorcado) =
    if fueAdivinado intentos c || not (Char.isAlpha c) then
        ahorcado

    else
        Ahorcado (c :: intentos) palabra


fueAdivinado : List Char -> Char -> Bool
fueAdivinado cs c =
    List.member (Char.toLower c) (List.map Char.toLower cs)


mostrar : Ahorcado -> String
mostrar (Ahorcado intentos palabras) =
    let
        remplazar adivinados c =
            if fueAdivinado adivinados c then
                c

            else
                '_'
    in
    String.toList palabras
        |> List.map (remplazar intentos)
        |> List.intersperse ' '
        |> String.fromList


getIntentos : Ahorcado -> List Char
getIntentos (Ahorcado intentos _) =
    List.reverse intentos
