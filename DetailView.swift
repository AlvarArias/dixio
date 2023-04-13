//
//  DetailView.swift
//  DiccionarioApp
//
//  Created by Alvar Arias on 2023-03-17.
//

import SwiftUI

struct DetailView: View {
    //MARK: Env
    @EnvironmentObject var appEnvironment: AppEnvironment
    
    // MARK: ObsObjects
    @ObservedObject var player = PlayerWord()
    
    // MARK: Core Data
    @Environment(\.managedObjectContext) var myNewWord

    // MARK: State
    @State private var isPlaying : Bool = false
    @State private var isSavedCData : Bool = false
    
    @Binding var selectedLang: Bool
    
    let result : Result
    
    var body: some View {
            
       Form {
            
            WordInfoView(result: result, saveWordToCoreData: {
                saveWordToCoreData()
            })
            
            LanguageInfoView(result: result, selectedLang: selectedLang)
            
            AudioPlaybackView(player: player, phonetic: result.baseLang?.phonetic)

        }
        .shadow(color: .gray, radius: 0.5, x: 0.5, y: -0.5)
        .padding()
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
        .overlay(
                    Group {
                        if isSavedCData {
                            NotificationCore(text:LocalizedStringKey("saving"))
                                .transition(.move(edge: .top))
                        }
                    }
                )
        .environment(\.locale, .init(identifier: appEnvironment.currentLanguage))
    }
    
    func saveWordToCoreData() {
         
         // Try to save in Core Data
            let theSelectedWord = myWord(context: myNewWord)
            // Fix values
        theSelectedWord.value = result.value ?? "No value"
        theSelectedWord.type = result.type ?? "No type"
        
        theSelectedWord.phonetic = result.baseLang?.phonetic?.content ?? ""
        theSelectedWord.file = result.baseLang?.phonetic?.file ?? ""
           
            // Selected language
            if selectedLang {
                
                theSelectedWord.translation = result.targetLang?.translation ?? "No translation"
                theSelectedWord.synonym = result.targetLang?.synonym?.first ?? ""
                
            } else {
                
                theSelectedWord.meaning = result.baseLang?.meaning ?? "No meaning"
                    
            }

        
        do {
               try myNewWord.save()
            
                showNotifCoreData()
               
           } catch {
               print("Error saving the word to Core Data: \(error)")
           }
        
  
        }
    
    func showNotifCoreData() {
        
        isSavedCData = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {

            withAnimation {
                isSavedCData = false
            }
        }
        
    }
        
}



struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(player: PlayerWord(), selectedLang: .constant(false), result: .init(variantID: "variantID", value: "value", type: "type", baseLang: BaseLang(phonetic: Phonetic(file: "file", content: "content"), inflection: [Inflection(content: "content")], meaning: "meaning", illustration: [Illustration(type: "type", value: "value")], comment: "comment"), targetLang: TargetLang(translation: "translation", synonym: ["synonym"], comment: "comment")))
    }
}



