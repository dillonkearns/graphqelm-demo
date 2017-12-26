module Swapi.Object.Droid exposing (..)

{-| Code for retrieving fields from a Character in a type-safe way.
@docs selection, appearsIn, friends, id, name, primaryFunction
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
selection : (a -> constructor) -> SelectionSet (a -> constructor) Swapi.Object.Droid
selection constructor =
    Object.object constructor


{-| Episodes the Droid appears in.
-}
appearsIn : FieldDecoder (List Swapi.Enum.Episode.Episode) Swapi.Object.Droid
appearsIn =
    Object.fieldDecoder "appearsIn" [] (Swapi.Enum.Episode.decoder |> Decode.list)


{-| Droid's friends.
-}
friends : SelectionSet friends Swapi.Object.Character -> FieldDecoder (List friends) Swapi.Object.Droid
friends object =
    Object.listOf "friends" [] object


{-| Droid's id.
-}
id : FieldDecoder String Swapi.Object.Droid
id =
    Object.fieldDecoder "id" [] Decode.string


{-| Droid's name.
-}
name : FieldDecoder String Swapi.Object.Droid
name =
    Object.fieldDecoder "name" [] Decode.string


{-| Droid's primary function.
-}
primaryFunction : FieldDecoder String Swapi.Object.Droid
primaryFunction =
    Object.fieldDecoder "primaryFunction" [] Decode.string
