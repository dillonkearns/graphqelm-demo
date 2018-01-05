module Swapi.Object.Human exposing (..)

{-| Code for retrieving fields from a Human in a type-safe way.
@docs selection, appearsIn, friends, id, name, homePlanet
-}

import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.Object as Object
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import Swapi.Enum.Episode
import Swapi.Interface
import Swapi.Object
import Swapi.Union


{-| Select fields to build up a SelectionSet for this object.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) Swapi.Object.Human
selection constructor =
    Object.selection constructor


{-| Which movies they appear in.
-}
appearsIn : FieldDecoder (List Swapi.Enum.Episode.Episode) Swapi.Object.Human
appearsIn =
    Object.fieldDecoder "appearsIn" [] (Swapi.Enum.Episode.decoder |> Decode.list)


{-| The friends of the human, or an empty list if they have none.
-}
friends : SelectionSet selection Swapi.Interface.Character -> FieldDecoder (List selection) Swapi.Object.Human
friends object =
    Object.selectionFieldDecoder "friends" [] object (identity >> Decode.list)


{-| The home planet of the human, or null if unknown.
-}
homePlanet : FieldDecoder (Maybe String) Swapi.Object.Human
homePlanet =
    Object.fieldDecoder "homePlanet" [] (Decode.string |> Decode.maybe)


{-| The ID of the human.
-}
id : FieldDecoder String Swapi.Object.Human
id =
    Object.fieldDecoder "id" [] Decode.string


{-| The name of the human.
-}
name : FieldDecoder String Swapi.Object.Human
name =
    Object.fieldDecoder "name" [] Decode.string
