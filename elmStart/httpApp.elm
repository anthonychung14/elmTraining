module HttpReq exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App

import Styles
import Http

--TODO: FIGURE OUT BETTER DEFAULTS THAN "NONE"
--MODELS
type alias Problem = { 
  problems: Int, 
  dataStruct: String }

type alias Folders = 
  { name: String
  , url: String
  }

model : (Problem, Folders)
model = 
  (
    { problems = 0, dataStruct = "None" },
    { name = "None", url = "None"}
  )


--VIEWS
view : (Problem, Folders) -> Html Msg
view model =
  div [ Styles.mainStyle ]
  [ h1 [] [text "HTTP Requests"]
  , div [] [
    button [] [text "GET from Github"]]
  ]


--UPDATE
update msg model =
  model

type Msg =
  NoOp
  | Fail Http.Error
  | GetDone (List Folders)
  | GetStart


--MAIN
main =
  App.beginnerProgram
      { model = model
      , view = view
      , update = update }