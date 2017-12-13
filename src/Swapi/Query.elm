module Swapi.Query exposing (build, droid, hero, human)

{-| The top-level query for the GraphQL endoint which you can explore at
[graphqelm.herokuapp.com](https://graphqelm.herokuapp.com)

@docs build, droid, hero, human

-}

import Graphqelm exposing (RootQuery)
import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.RootObject as RootObject
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.Object exposing (Object)
import Swapi.Enum.Episode
import Swapi.Object


{-| Create a top-level query.
-}
build : (a -> constructor) -> Object (a -> constructor) RootQuery
build constructor =
    RootObject.object constructor


{-| Top-level query to retrieve a droid.
-}
droid : { id : String } -> Object droid Swapi.Object.Droid -> FieldDecoder droid RootQuery
droid requiredArgs object =
    RootObject.single "droid" [ Argument.string "id" requiredArgs.id ] object


{-| Top-level query to retrieve a hero.
-}
hero : ({ episode : Maybe Swapi.Enum.Episode.Episode } -> { episode : Maybe Swapi.Enum.Episode.Episode }) -> Object hero Swapi.Object.Character -> FieldDecoder hero RootQuery
hero fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { episode = Nothing }

        optionalArgs =
            [ Argument.optional "episode" filledInOptionals.episode (Encode.enum toString) ]
                |> List.filterMap identity
    in
    RootObject.single "hero" optionalArgs object


{-| Top-level query to retrieve a human.
-}
human : { id : String } -> Object human Swapi.Object.Human -> FieldDecoder human RootQuery
human requiredArgs object =
    RootObject.single "human" [ Argument.string "id" requiredArgs.id ] object
