<p align="center">
  <img src="https://user-images.githubusercontent.com/7523384/231671652-23e15e19-e2cf-44ad-a15b-7ef747ee2fcf.png"  width="200" height="200">
  <h1 align="center">Dixio is a dictionary SwiftUI App</h1>
</p>

## Introduction: 
Introducing Dixio App, is a dictionary Spanish / Swedish App , designed to provide users with synonyms, definitions, and pronunciations of words.

## App overview 
Dioxio App is a comprehensive dictionary application that combines various technologies to provide users with a seamless experience when searching for word definitions, synonyms, and pronunciations

## Read Data
The app uses an open JSON API from "Lexin på net," which is a collaboration between the Institute for Language and Folklore and the Royal Institute of Technology of Sweden. 
This API provides the app with the necessary word data. [here](https://lexin.nada.kth.se/lexin/#about=1;main=3;)


## Record data
Dioxio App utilizes Core Data to save selected words, which allows users to view their search history. 

## Data arquitecture
The app utilizes the Model-View-ViewModel (MVVM) architecture for the data model.
This pattern separates the application into three main components - model (data), view (presentation), and view model (logic) - to improve organization and maintainability. 

To handle errors and notifications to the user interface, Dioxio App employs Combine.
Combine framework provides a declarative Swift API for processing values over time. Documentation [here](https://developer.apple.com/documentation/combine) 

## Localization
The app is localized in three languages: Swedish, Spanish, and English, providing a broad range of users with access to its features.


## Frames
The app use AVplayer apple frame to strean and play the word sound from the internet.

### Video
https://user-images.githubusercontent.com/7523384/231676223-a123bdf7-23dd-4632-8979-5f98551f0335.mov

Download <br>
<a href="https://apps.apple.com/app/dixio/id6446829036">App Store</a>
<br>
@Alvar Arias
