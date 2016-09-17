module HttpReq exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App

import Styles
import Http

-- Wait what does the (:=) end up doing?
import Json.Decode as Decode exposing ((:=))
import Task

--MODELS
--Describes the shape of a subItem
type alias Folder = 
  { name: String
  , html_url: String
  }

--Describes the shape of the whole state tree
type alias Model =
  { message: String
  , folders: List Folder
  }

--TODO: FIGURE OUT BETTER DEFAULTS THAN "NONE"
--After choosing, this will start the timer and display the random problem
type alias Problem = 
  { time: Int 
  , dataStruct: String 
  }

init: (Model, Cmd Msg)
init = 
  let
    model =
    { message = "Hello there"
    , folders = []
    }
  in
    (model, Cmd.none)
  

--VIEWS
view : Model -> Html Msg
view model =
  let
    showFolder folder =
      li []
        [ text folder.name ]
  in
    div [ Styles.mainStyle ]
    [ h1 [] [text "HTTP Requests"]
    , h2 [] [text model.message]
    , div [] [      
      button [onClick GitStart] [text "GET from Github"]]
    , ul [] (List.map showFolder model.folders)
    ]

--UPDATE
type Msg =
  NoOp  
  | GitStart
  | FetchSucceed (List Folder)
  | FetchFail Http.Error

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of    
    NoOp ->
      model ! []
    
    GitStart ->
      ({ model | message = "INITIALIZE" }, fetchAll)

    FetchFail err ->
      ({ model | message = "ERROR IN FETCH" ++ (toString err) }, Cmd.none)
    
    FetchSucceed folders ->
      ({ model | folders = folders, message = "FETCHED DATA" }, Cmd.none) 

--HTTP REQS
fetchUrl: String
fetchUrl = "https://api.github.com/repos/anthonychung14/algorithms/contents"
--fetchUrl = "https://api.github.com/repos/anthonychung14/gitajob/contents"

fetchAll: Cmd Msg
fetchAll =
  Http.get decodeFolders fetchUrl
    |> Task.perform FetchFail FetchSucceed

decodeFolders: Decode.Decoder (List Folder)
decodeFolders =    
  Decode.list folderDecoder

folderDecoder: Decode.Decoder Folder
folderDecoder =
  Decode.object2 Folder
    ("name" := Decode.string)  
    ("html_url" := Decode.string)  

--MAIN
main: Program Never
main =
  App.program
      { init = init
      , view = view
      , update = update 
      , subscriptions = \_ -> Sub.none
      }