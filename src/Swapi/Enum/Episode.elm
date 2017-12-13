module Swapi.Enum.Episode exposing (..)

{-| Enum for all episodes that the API has in its system.
@docs Episode, decoder
-}

import Json.Decode as Decode exposing (Decoder)


{-| Episode enum.
-}
type Episode
    = EMPIRE
    | JEDI
    | NEWHOPE


{-| Decode an Episode from the GraphQL endpoint.
-}
decoder : Decoder Episode
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "EMPIRE" ->
                        Decode.succeed EMPIRE

                    "JEDI" ->
                        Decode.succeed JEDI

                    "NEWHOPE" ->
                        Decode.succeed NEWHOPE

                    _ ->
                        Decode.fail ("Invalid Episode type, " ++ string ++ " try re-running the graphqelm CLI ")
            )
