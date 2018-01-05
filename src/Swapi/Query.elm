module Swapi.Query exposing (..)

{-| The top-level query for the GraphQL endoint which you can explore at
[graphqelm.herokuapp.com](https://graphqelm.herokuapp.com)

@docs selection, droid, hero, heroUnion, human

-}

import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.Object as Object
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import Swapi.Enum.Episode
import Swapi.Interface
import Swapi.Object
import Swapi.Union


{-| Select fields to build up a top-level query. The request can be sent with
functions from `Graphqelm.Http`.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) RootQuery
selection constructor =
    Object.selection constructor


{-|

  - id - ID of the droid.

-}
droid : { id : String } -> SelectionSet selection Swapi.Object.Droid -> FieldDecoder (Maybe selection) RootQuery
droid requiredArgs object =
    Object.selectionFieldDecoder "droid" [ Argument.required "id" requiredArgs.id Encode.string ] object (identity >> Decode.maybe)


{-|

  - episode - If omitted, returns the hero of the whole saga. If provided, returns the hero of that particular episode.

-}
hero : ({ episode : OptionalArgument Swapi.Enum.Episode.Episode } -> { episode : OptionalArgument Swapi.Enum.Episode.Episode }) -> SelectionSet selection Swapi.Interface.Character -> FieldDecoder selection RootQuery
hero fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { episode = Absent }

        optionalArgs =
            [ Argument.optional "episode" filledInOptionals.episode (Encode.enum Swapi.Enum.Episode.toString) ]
                |> List.filterMap identity
    in
    Object.selectionFieldDecoder "hero" optionalArgs object identity


{-|

  - episode - If omitted, returns the hero of the whole saga. If provided, returns the hero of that particular episode.

-}
heroUnion : ({ episode : OptionalArgument Swapi.Enum.Episode.Episode } -> { episode : OptionalArgument Swapi.Enum.Episode.Episode }) -> SelectionSet selection Swapi.Union.CharacterUnion -> FieldDecoder (Maybe selection) RootQuery
heroUnion fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { episode = Absent }

        optionalArgs =
            [ Argument.optional "episode" filledInOptionals.episode (Encode.enum Swapi.Enum.Episode.toString) ]
                |> List.filterMap identity
    in
    Object.selectionFieldDecoder "heroUnion" optionalArgs object (identity >> Decode.maybe)


{-|

  - id - ID of the human.

-}
human : { id : String } -> SelectionSet selection Swapi.Object.Human -> FieldDecoder (Maybe selection) RootQuery
human requiredArgs object =
    Object.selectionFieldDecoder "human" [ Argument.required "id" requiredArgs.id Encode.string ] object (identity >> Decode.maybe)
