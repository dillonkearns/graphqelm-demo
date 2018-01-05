module Main exposing (main)

import Graphqelm.Document as Document
import Graphqelm.FieldDecoder as FieldDecoder
import Graphqelm.Http
import Graphqelm.Operation exposing (RootQuery)
import Graphqelm.SelectionSet exposing (SelectionSet, with)
import Html exposing (Html, a, div, h1, h2, p, pre, text)
import Html.Attributes exposing (href, target)
import RemoteData exposing (RemoteData)
import Swapi.Enum.Episode as Episode exposing (Episode)
import Swapi.Interface
import Swapi.Interface.Character as Character
import Swapi.Object
import Swapi.Object.Human as Human
import Swapi.Query as Query


type alias Response =
    { tarkin : Maybe Human
    , vader : Maybe Human
    , hero : Hero
    }


query : SelectionSet Response RootQuery
query =
    -- define the top-level query
    -- this syntax is based on the json decode pipeline pattern
    Query.selection Response
        |> with (Query.human { id = "1004" } human)
        |> with (Query.human { id = "1001" } human)
        |> with (Query.hero identity hero)


type alias Hero =
    -- as with JSON decoding, it's common to use type alias constructors
    { name : String
    , id : String
    , friends : List String
    , appearsIn : List Episode
    }


hero : SelectionSet Hero Swapi.Interface.Character
hero =
    Character.commonSelection Hero
        |> with Character.name
        |> with Character.id
        |> with (Character.friends heroWithName)
        |> with Character.appearsIn


heroWithName : SelectionSet String Swapi.Interface.Character
heroWithName =
    Character.commonSelection identity
        |> with Character.name


type alias Human =
    { name : String
    , yearsActive : List Int
    }


human : SelectionSet Human Swapi.Object.Human
human =
    Human.selection Human
        |> with Human.name
        |> with
            (Human.appearsIn
                -- FieldDecoder.map can be used to arbitraliy map
                -- any field in your query
                |> FieldDecoder.map (List.map episodeYear)
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


makeRequest : Cmd Msg
makeRequest =
    query
        |> Graphqelm.Http.buildQueryRequest
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
        [ h2 [] [ text "About Graphqelm" ]
        , p []
            [ text "Swapi (Star Wars API) is the standard GraphQL example schema. The Swapi modules were auto-generated using the "
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
