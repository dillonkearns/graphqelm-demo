module Main exposing (main)

import Graphqelm.Document as Document
import Graphqelm.Field as Field
import Graphqelm.Http
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import Html exposing (Html, a, div, h1, h2, img, p, pre, text)
import Html.Attributes exposing (align, href, src, target, width)
import RemoteData exposing (RemoteData)
import Swapi.Enum.Episode as Episode exposing (Episode)
import Swapi.Interface
import Swapi.Interface.Character as Character
import Swapi.Object
import Swapi.Object.Droid as Droid
import Swapi.Object.Human as Human
import Swapi.Query as Query
import Swapi.Scalar


type alias Response =
    { tarkin : Maybe Human
    , vader : Maybe Human
    , hero : Hero
    }


query : SelectionSet Response RootQuery
query =
    -- Define the top-level query.
    -- This syntax is based on the json decode pipeline pattern.
    Query.selection Response
        |> with (Query.human { id = Swapi.Scalar.Id "1004" } human)
        |> with (Query.human { id = Swapi.Scalar.Id "1001" } human)
        |> with (Query.hero identity hero)


type alias Human =
    -- As with JSON decoding, it's common to use type alias constructors.
    { name : String
    , yearsActive : List Int
    }


human : SelectionSet Human Swapi.Object.Human
human =
    -- Since a query is just an object in GraphQL,
    -- the syntax for building a SelectionSet is
    -- exactly the same for a Human object.
    Human.selection Human
        |> with Human.name
        |> with
            (Human.appearsIn
                -- Field.map can be used to arbitraliy map
                -- any field in your query.
                |> Field.map (List.map episodeYear)
            )


episodeYear : Episode -> Int
episodeYear episode =
    case episode of
        Episode.Newhope ->
            1977

        Episode.Empire ->
            1980

        Episode.Jedi ->
            1983


type
    HumanOrDroidDetails
    -- Interfaces have type-specific attributes as well as common attributes
    -- With Graphqelm, we represent the type-specific attributes with a union type.
    = HumanDetails (Maybe String)
    | DroidDetails (Maybe String)


type alias Hero =
    { details : Maybe HumanOrDroidDetails
    , name : String

    -- non-primitive scalars are simple strings wrapped in type constructors
    -- you can unwrap a scalar with a case statement or function like this:
    -- (\(Swapi.Scalar.Id rawId) -> rawId)
    , id : Swapi.Scalar.Id
    , friends : List String
    , appearsIn : List Episode
    }


hero : SelectionSet Hero Swapi.Interface.Character
hero =
    Character.selection Hero
        -- The selection function for interfaces takes a list of type-specific
        -- selections that all decode into the same type (typically a union)
        [ Character.onDroid (Droid.selection DroidDetails |> with Droid.primaryFunction)
        , Character.onHuman (Human.selection HumanDetails |> with Human.homePlanet)
        ]
        -- followed by all of the common attributes
        -- (both Droids and Humans have these)
        |> with Character.name
        |> with Character.id
        |> with (Character.friends heroWithName)
        |> with Character.appearsIn


heroWithName : SelectionSet String Swapi.Interface.Character
heroWithName =
    Character.commonSelection identity
        |> with Character.name


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphqelm.Http.queryRequest
            "https://graphqelm.herokuapp.com/api"
        |> Graphqelm.Http.send (RemoteData.fromResult >> GotResponse)


type Msg
    = GotResponse Model


type alias Model =
    RemoteData Graphqelm.Http.Error Response


init : ( Model, Cmd Msg )
init =
    ( RemoteData.Loading
    , makeRequest
    )


view : Model -> Html.Html Msg
view model =
    div []
        [ div []
            [ h1 [] [ text "Generated Query" ]
            , pre [] [ text (Document.serializeQuery query) ]
            ]
        , div []
            [ h1 [] [ text "Response" ]
            , Html.text (toString model)
            ]
        , aboutView
        ]


aboutView : Html Msg
aboutView =
    div []
        [ h2 [] [ text "About ", a [ href "https://github.com/dillonkearns/graphqelm", target "_blank" ] [ text "Graphqelm", img [ src "https://cdn.rawgit.com/martimatix/logo-graphqelm/master/logo.svg" ] [] ] ]
        , p []
            [ text "Swapi (Star Wars API) is the standard GraphQL example schema (see "
            , a [ href "http://graphql.org/learn/", target "_blank" ] [ text "the GraphQL tutorial" ]
            , text "). The Swapi modules were auto-generated using the "
            , a [ target "_blank", href "https://github.com/dillonkearns/graphqelm" ] [ text "graphqelm" ]
            , text " CLI."
            ]
        , p []
            [ text "You can play with the "
            , a [ target "_blank", href "https://graphqelm.herokuapp.com/" ] [ text "interactive GraphQL editor for this api" ]
            , text " or view the "
            , a [ target "_blank", href "https://github.com/dillonkearns/graphqelm-demo" ] [ text "source code." ]
            , text " Or experiment with the code right here in Ellie!"
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotResponse response ->
            ( response, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
