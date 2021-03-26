module MainTest exposing (..)

import Expect exposing (fail)
import Html
import Main
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text)
import Url


suite : Test
suite =
    describe "The Main module"
        [ describe "viewPage"
            [ test "Displays the current url" <|
                \() ->
                    case Url.fromString "http://localhost:8080/abcd" of
                        Just url ->
                            Main.viewPage url
                                |> Html.div []
                                |> Query.fromHtml
                                |> Query.has [ text "http://localhost:8080/abcd" ]

                        Nothing ->
                            fail "should not happen, Url considered invalid"
            ]
        ]
