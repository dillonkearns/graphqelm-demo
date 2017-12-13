module Swapi.Object.Droid exposing (..)

import Swapi.Enum.Episode
import Swapi.Object
import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.Object as Object
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.Object exposing (Object)
import Json.Decode as Decode


build : (a -> constructor) -> Object (a -> constructor) Swapi.Object.Droid
build constructor =
    Object.object constructor


appearsIn : FieldDecoder (List Swapi.Enum.Episode.Episode) Swapi.Object.Droid
appearsIn =
    Object.fieldDecoder "appearsIn" [] (Swapi.Enum.Episode.decoder |> Decode.list)


friends : Object friends Swapi.Object.Character -> FieldDecoder (List friends) Swapi.Object.Droid
friends object =
    Object.listOf "friends" [] object


id : FieldDecoder String Swapi.Object.Droid
id =
    Object.fieldDecoder "id" [] Decode.string


name : FieldDecoder String Swapi.Object.Droid
name =
    Object.fieldDecoder "name" [] Decode.string


primaryFunction : FieldDecoder String Swapi.Object.Droid
primaryFunction =
    Object.fieldDecoder "primaryFunction" [] Decode.string
