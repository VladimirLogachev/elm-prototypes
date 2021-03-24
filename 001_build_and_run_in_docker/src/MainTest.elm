module MainTest exposing (..)

import Main
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text)


suite : Test
suite =
    describe "The Main module"
        [ describe "main"
            [ test "Button has the expected text" <|
                \() ->
                    Main.main
                        |> Query.fromHtml
                        |> Query.has [ text "hello world" ]
            ]
        ]
