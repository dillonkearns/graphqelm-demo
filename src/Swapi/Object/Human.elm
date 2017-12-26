module Swapi.Object.Human exposing (..)

{-| Code for retrieving fields from a Character in a type-safe way.
@docs selection, appearsIn, friends, id, name, homePlanet
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
selection : (a -> constructor) -> SelectionSet (a -> constructor) Swapi.Object.Human
selection constructor =
    Object.object constructor


{-| Episodes the Human appears in.
-}
appearsIn : FieldDecoder (List Swapi.Enum.Episode.Episode) Swapi.Object.Human
appearsIn =
    Object.fieldDecoder "appearsIn" [] (Swapi.Enum.Episode.decoder |> Decode.list)


{-| Human's friends.
-}
friends : SelectionSet friends Swapi.Object.Character -> FieldDecoder (List friends) Swapi.Object.Human
friends object =
    Object.listOf "friends" [] object


{-| Human's id.
-}
homePlanet : FieldDecoder String Swapi.Object.Human
homePlanet =
    Object.fieldDecoder "homePlanet" [] Decode.string


{-| Human's name.
-}
id : FieldDecoder String Swapi.Object.Human
id =
    Object.fieldDecoder "id" [] Decode.string


{-| Human's home planet.
-}
name : FieldDecoder String Swapi.Object.Human
name =
    Object.fieldDecoder "name" [] Decode.string
