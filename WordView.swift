//
//  WordView.swift
//  DiccionarioApp
//
//  Created by Alvar Arias on 2023-03-17.
//

import SwiftUI

struct WordView: View {

    //MARK: Env
    @EnvironmentObject var appEnvironment: AppEnvironment
    
    // MARK: ObsObjects
    @ObservedObject var myviewModelWord = WordViewModel()
    
    // MARK: State
    @State private var text = ""
    @State private var selectedLang = true
    @State private var errorMessage: String = ""
    @State private var showProgressBarr = false
    
    @State private var showHistory = false
    @State private var showSavedWord = false
    @State private var showQuiz = false
    @State private var showSettings = false
    
    @State private var isVStackVisible = false
    
    
    @State private var newWord: String = ""
    @State var searchWords: [String] = [String]()
    
    @State private var selectedTab = 1
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Selection Lang View
                LanguageSelectionView(selectedLang: $selectedLang, errorMessage: $errorMessage, showProgressBar: $showProgressBarr, myviewModelWord: myviewModelWord)
                
                // Search Bar
                SearchBarView(text: $text, searchWords: $searchWords, showProgressBar: $showProgressBarr, myviewModelWord: myviewModelWord, selectedLang: selectedLang)
                
                // New List Search
                ScrollView {
                    
                    if showProgressBarr {
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                            .padding()
                        
                    }
                    
                    if errorMessage == "OK" {
                        
                        // Reult List
                        ResultsListView(selectedLang: $selectedLang, isVStackVisible: $isVStackVisible, showProgressBar: $showProgressBarr, myviewModelWord: myviewModelWord)
                        
                    }
                    
                }
                
                
                
            }

            .navigationTitle(LocalizedStringKey("home"))
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color(UIColor(red: 0.45, green: 0.92, blue: 0.84, alpha: 0.5)),
                            Color(UIColor(red: 0.67, green: 0.71, blue: 0.90, alpha: 0.5))
                        ]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
        }
        
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                settingsButton()
                Spacer()
                //quizButton()
                //Spacer()
                historyButton()
                Spacer()
                savedWordButton()
            }
    
        }
        
        .environment(\.locale, .init(identifier: appEnvironment.currentLanguage))

    }
        
    private func historyButton() -> some View {
        Button(action: { showHistory.toggle() }) {
            Image(systemName: "list.bullet")
                .foregroundColor(Color.orange)
        }
        .sheet(isPresented: $showHistory) {
            FavoriteView(searchWors: $searchWords)
        }
    }

    private func quizButton() -> some View {
        Button(action: { showQuiz.toggle() }) {
            Image(systemName: "wand.and.stars")
                .foregroundColor(Color.orange)
        }
        .sheet(isPresented: $showQuiz) {
            //QuizView()
            ChatView()
        }
    }
    
    private func settingsButton() -> some View {
        Button(action: { showSettings.toggle() }) {
            Image(systemName: "gear")
                .foregroundColor(Color.orange)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    private func savedWordButton() -> some View {
        Button(action: { showSavedWord.toggle() }) {
            Image(systemName: "checklist.checked")
                .foregroundColor(Color.orange)
        }
        .sheet(isPresented: $showSavedWord) {
            SavedWordView()
        }
    }
}

struct WordView_Previews: PreviewProvider {
    static var previews: some View {
        WordView()
    }
}




