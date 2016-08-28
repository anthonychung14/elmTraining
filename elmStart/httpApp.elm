module HttpReq exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App

import Styles
import Http
import Json.Decode as Json
import Task

--TODO: FIGURE OUT BETTER DEFAULTS THAN "NONE"
--MODELS
type alias Problem = 
  { time: Int 
  , dataStruct: String 
  }

type alias Folder = 
  { name: String
  , html_url: String
  }

init : (Folder, Cmd Msg)
init = 
  (
    { name = "Stuff"
    , html_url = "None"
    },
    Cmd.none
  )
  

--VIEWS
view : Folder -> Html Msg
view model =
  div [ Styles.mainStyle ]
  [ h1 [] [text "HTTP Requests"]
  , div [] [
    button [onClick GitStart] [text "GET from Github"]]
  ]

--UPDATE
type Msg =
  NoOp  
  | GitStart
  | FetchSucceed String
  | FetchFail Http.Error

update: Msg -> Folder -> (Folder, Cmd Msg)
update msg model =
  case msg of
    
    NoOp ->
      (model, Cmd.none)
    
    GitStart ->
      (model, getFolders url)

    FetchFail _ ->
      (model, Cmd.none)
    
    FetchSucceed newUrl ->
      (Folder model.name newUrl, Cmd.none)
    
    
fetchUrl: String
fetchUrl = "https://api.github.com/repos/anthonychung14/gitajob/contents"

fetchAll: Cmd Msg
fetchAll =
  Http.get decodeFolders fetchUrl
    |> Task.perform FetchFail FetchSucceed

decodeFolders: Json.Decode.Decoder (List Folder)
decodeFolders =
  Json.at ["data"] 
  Json.Decode.list folderDecoder

folderDecoder: Json.Decode.Decoder Folder
folderDecoder =
  Json.Decode.object3 Folder
    ("name" := Decode.string)  
    ("html_url" := Decode.string)  


--HTTP REQS
getFolders getUrl =
  Task.perform FetchFail FetchSucceed (Http.get decodeFolders getUrl)

--MAIN
main: Program Never
main =
  App.program
      { init = init
      , view = view
      , update = update 
      , subscriptions = subscriptions
      }

-- SUBSCRIPTIONS
subscriptions : Folder -> Sub Msg
subscriptions model =
    Sub.none