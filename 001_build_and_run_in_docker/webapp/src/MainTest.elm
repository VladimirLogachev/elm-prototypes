module MainTest exposing (..)

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
                    let
                        url =
                            { protocol = Url.Http
                            , host = "localhost"
                            , port_ = Nothing
                            , path = "/abcd"
                            , query = Nothing
                            , fragment = Nothing
                            }
                    in
                    Main.viewPage url
                        |> Html.div []
                        |> Query.fromHtml
                        |> Query.has [ text "/abcd" ]
            ]
        ]
