module Swapi.Query exposing (..)

import Swapi.Enum.Episode
import Swapi.Object
import Graphqelm exposing (RootQuery)
import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.Object as Object
import Graphqelm.Builder.RootObject as RootObject
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.Object exposing (Object)
import Json.Decode as Decode exposing (Decoder)


build : (a -> constructor) -> Object (a -> constructor) RootQuery
build constructor =
    RootObject.object constructor


droid : { id : String } -> Object droid Swapi.Object.Droid -> FieldDecoder droid RootQuery
droid requiredArgs object =
    RootObject.single "droid" [ Argument.string "id" requiredArgs.id ] object


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


human : { id : String } -> Object human Swapi.Object.Human -> FieldDecoder human RootQuery
human requiredArgs object =
    RootObject.single "human" [ Argument.string "id" requiredArgs.id ] object
