module Swapi.Query exposing (..)

{-| The top-level query for the GraphQL endoint which you can explore at
[graphqelm.herokuapp.com](https://graphqelm.herokuapp.com)

@docs selection, droid, hero, human

-}

import Graphqelm exposing (RootQuery)
import Graphqelm.Builder.Argument as Argument exposing (Argument)
import Graphqelm.Builder.Object as Object
import Graphqelm.Encode as Encode exposing (Value)
import Graphqelm.FieldDecoder as FieldDecoder exposing (FieldDecoder)
import Graphqelm.OptionalArgument exposing (OptionalArgument(Absent))
import Graphqelm.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)
import Swapi.Enum.Episode
import Swapi.Object


{-| Create a top-level query.
-}
selection : (a -> constructor) -> SelectionSet (a -> constructor) RootQuery
selection constructor =
    Object.object constructor


{-|

  - id - ID of the droid.

-}
droid : { id : String } -> SelectionSet droid Swapi.Object.Droid -> FieldDecoder (Maybe droid) RootQuery
droid requiredArgs object =
    Object.selectionFieldDecoder "droid" [ Argument.required "id" requiredArgs.id Encode.string ] object (identity >> Decode.maybe)


{-|

  - episode - If omitted, returns the hero of the whole saga. If provided, returns the hero of that particular episode.

-}
hero : ({ episode : OptionalArgument Swapi.Enum.Episode.Episode } -> { episode : OptionalArgument Swapi.Enum.Episode.Episode }) -> SelectionSet hero Swapi.Object.Character -> FieldDecoder (Maybe hero) RootQuery
hero fillInOptionals object =
    let
        filledInOptionals =
            fillInOptionals { episode = Absent }

        optionalArgs =
            [ Argument.optional "episode" filledInOptionals.episode (Encode.enum toString) ]
                |> List.filterMap identity
    in
    Object.selectionFieldDecoder "hero" optionalArgs object (identity >> Decode.maybe)


{-|

  - id - ID of the human.

-}
human : { id : String } -> SelectionSet human Swapi.Object.Human -> FieldDecoder (Maybe human) RootQuery
human requiredArgs object =
    Object.selectionFieldDecoder "human" [ Argument.required "id" requiredArgs.id Encode.string ] object (identity >> Decode.maybe)
