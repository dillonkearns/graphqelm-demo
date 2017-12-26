module Swapi.Query exposing (..)

{-| The top-level query for the GraphQL endoint which you can explore at
[graphqelm.herokuapp.com](https://graphqelm.herokuapp.com)

@docs selection, droid, hero, human

-}

import Graphqelm exposing (RootQuery)
import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.Object as Object
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import Swapi.Enum.Episode
import Swapi.Object


{-| Create a top-level query.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) RootQuery
selection constructor =
    Object.object constructor


{-| Top-level query to retrieve a droid.
-}
droid : { id : String } -> SelectionSet droid Swapi.Object.Droid -> FieldDecoder droid RootQuery
droid requiredArgs object =
    Object.single "droid" [ Argument.string "id" requiredArgs.id ] object


{-| Top-level query to retrieve a hero.
-}
hero : ({ episode : Maybe Swapi.Enum.Episode.Episode } -> { episode : Maybe Swapi.Enum.Episode.Episode }) -> SelectionSet hero Swapi.Object.Character -> FieldDecoder hero RootQuery
hero fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { episode = Nothing }

        optionalArgs =
            [ Argument.optional "episode" filledInOptionals.episode (Encode.enum toString) ]
                |> List.filterMap identity
    in
    Object.single "hero" optionalArgs object


{-| Top-level query to retrieve a human.
-}
human : { id : String } -> SelectionSet human Swapi.Object.Human -> FieldDecoder human RootQuery
human requiredArgs object =
    Object.single "human" [ Argument.string "id" requiredArgs.id ] object
