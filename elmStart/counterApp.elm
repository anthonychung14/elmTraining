module Hello exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App

type alias Model = { problems: Int, username: String }
type Msg = 
    Increment Int 
  | Decrement Int  

model = {
  problems = 0,
  username = "Anthony" }

greeting = "Hello, " ++ model.username

update msg model =
  case msg of
    Increment amount -> { model | problems = model.problems + amount }    
    Decrement amount -> { model | problems = Basics.max 0 (model.problems - amount) }        

timerButton caption action =
  button
  [ onClick action ]
  [ text caption ] 

view model = 
  let
    isDisabled =
      model.problems <= 0
    caption = 
      greeting
      ++ ":   "
      ++ "You have "
      ++ toString model.problems 
      ++ " left "

  in 
    div [ mainStyle ]
    [ h1 [] [text "Algo Man"]    
    , div [] [ 
        button 
          [ disabled isDisabled, onClick (Decrement 2)]
          [ text "Stop timer"] ]
    , div [] [
          timerButton "Start timer" (Increment 10)]    
    , text caption
    ]
  

  
main =
    App.beginnerProgram
        { model = model
        , view = view
        , update = update }

mainStyle =
    style
        [ ( "font-family", "-apple-system, system, sans-serif" )
        , ( "margin", "10px" )
        , ( "padding", "40px" )
        , ( "display", "flex" )
        , ( "flex-direction", "column" )
        , ( "align-items", "stretch" )
        , ( "background-color", "#fafafa" )
        , ( "border", "lightgray solid 1px" )
        ]

inputStyle =
    style
        [ ( "border", "#fafafa solid" )
        , ( "border-bottom", "lightgray solid 1px" )
        , ( "font-size", "2em" )
        , ( "color", "rgba(0,0,0,0.75)" )
        , ( "background-color", "#fafafa" )
        ]

cardStyle =
    style
        [ ( "font-size", "2em" )
        , ( "color", "rgba(0,0,0,0.75)" )
        ]