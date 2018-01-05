module Swapi.Union.CharacterUnion exposing (..)

{-| Code for retrieving fields from a CharacterUnion in a type-safe way.
@docs selection, onHuman, onDroid
-}

import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.Object as Object
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (FragmentSelectionSet(FragmentSelectionSet), SelectionSet(SelectionSet))
import Json.Decode as Decode
import Swapi.Interface
import Swapi.Object
import Swapi.Union


{-| Specify fields to use for the object.
-}
selection : (Maybe typeSpecific -> constructor) -> List (FragmentSelectionSet typeSpecific Swapi.Union.CharacterUnion) -> SelectionSet constructor Swapi.Union.CharacterUnion
selection constructor typeSpecificDecoders =
    Object.unionSelection typeSpecificDecoders constructor


{-| Select the fields to use when the type is Human.
-}
onHuman : SelectionSet selection Swapi.Object.Human -> FragmentSelectionSet selection Swapi.Union.CharacterUnion
onHuman (SelectionSet fields decoder) =
    FragmentSelectionSet "Human" fields decoder


{-| Select fields to use when the type is Droid.
-}
onDroid : SelectionSet selection Swapi.Object.Droid -> FragmentSelectionSet selection Swapi.Union.CharacterUnion
onDroid (SelectionSet fields decoder) =
    FragmentSelectionSet "Droid" fields decoder
