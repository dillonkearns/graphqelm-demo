module Swapi.Object.Character exposing (..)

{-| Code for retrieving fields from a Character in a type-safe way.
@docs build, appearsIn, friends, id, name
-}

import Graphqelm.Builder.Object as Object
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.Object exposing (Object)
import Json.Decode as Decode
import Swapi.Enum.Episode
import Swapi.Object


{-| Specify the fields to use for the object.
-}
build : (a -> constructor) -> Object (a -> constructor) Swapi.Object.Character
build constructor =
    Object.object constructor


{-| Episodes the Character appears in.
-}
appearsIn : FieldDecoder (List Swapi.Enum.Episode.Episode) Swapi.Object.Character
appearsIn =
    Object.fieldDecoder "appearsIn" [] (Swapi.Enum.Episode.decoder |> Decode.list)


{-| Character's friends.
-}
friends : Object friends Swapi.Object.Character -> FieldDecoder (List friends) Swapi.Object.Character
friends object =
    Object.listOf "friends" [] object


{-| Character's id.
-}
id : FieldDecoder String Swapi.Object.Character
id =
    Object.fieldDecoder "id" [] Decode.string


{-| Character's name.
-}
name : FieldDecoder String Swapi.Object.Character
name =
    Object.fieldDecoder "name" [] Decode.string
