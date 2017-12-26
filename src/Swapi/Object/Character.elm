module Swapi.Object.Character exposing (..)

{-| Code for retrieving fields from a Character in a type-safe way.
@docs selection, appearsIn, friends, id, name
-}

import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.Object as Object
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import Swapi.Enum.Episode
import Swapi.Object


{-| Specify the fields to use for the object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) Swapi.Object.Character
selection constructor =
    Object.object constructor


{-| Episodes the Character appears in.
-}
appearsIn : FieldDecoder (List Swapi.Enum.Episode.Episode) Swapi.Object.Character
appearsIn =
    Object.fieldDecoder "appearsIn" [] (Swapi.Enum.Episode.decoder |> Decode.list)


{-| Character's friends.
-}
friends : SelectionSet friends Swapi.Object.Character -> FieldDecoder (List friends) Swapi.Object.Character
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
