//
//  WordViewModel.swift
//  DiccionarioApp
//
//  Created by Alvar Arias on 2023-03-17.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Words
struct Words: Codable {
    
    let status, wordbase: String
    let result: [Result]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case wordbase = "Wordbase"
        case result = "Result"
    }
}

// MARK: - Result
struct Result: Hashable, Identifiable, Codable {
    
    var id: String = UUID().uuidString
   
    let variantID: String?
    let value : String?
    let type: String?

    let baseLang: BaseLang?
    let targetLang: TargetLang?
  
    enum CodingKeys: String, CodingKey {
            case value = "Value"
            case type = "Type"
            case variantID = "VariantID"
            case baseLang = "BaseLang"
            case targetLang = "TargetLang"
        }
   
    
    

    
}

// MARK: - BaseLang
struct BaseLang: Hashable, Codable {
    let phonetic: Phonetic?
    let inflection: [Inflection]?
    let meaning: String?
    let illustration: [Illustration]?
    let comment: String?

    enum CodingKeys: String, CodingKey {
        case phonetic = "Phonetic"
        case inflection = "Inflection"
        case meaning = "Meaning"
        case illustration = "Illustration"
        case comment = "Comment"
    }
}

// MARK: - Illustration
struct Illustration: Hashable, Codable {
    let type: String?
    let value: String?

    enum CodingKeys: String, CodingKey {
        case type = "Type"
        case value = "Value"
    }
}

// MARK: - Inflection
struct Inflection: Hashable, Codable {
    let content: String?

    enum CodingKeys: String, CodingKey {
        case content = "Content"
    }
}

// MARK: - Phonetic
struct Phonetic: Hashable, Codable {
    let file: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case file = "File"
        case content = "Content"
    }
}

// MARK: - TargetLang
struct TargetLang: Hashable, Codable {
    let translation: String?
    let synonym: [String]?
    let comment: String?

    enum CodingKeys: String, CodingKey {
        case translation = "Translation"
        case synonym = "Synonym"
        case comment = "Comment"
    }
}


class WordViewModel: ObservableObject {
    
    // Errores con Combine
    private var cancellables = Set<AnyCancellable>()
    private let errorSubject = PassthroughSubject<String, Never>()
    
    var errorPublisher: AnyPublisher<String, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    @Published var results = [Result]()
    
    /// Fetches posts from a remote server.
    ///
    /// - Parameters:
    ///   - word: The word to search for.
    ///   - dir: The language direction to search in.
    ///
    /// - Note: The search direction should be specified as a comma-separated list of language codes in the format `source_lang-target_lang`.
    ///
    /// - Throws: An error if the URL is invalid or the server response is not valid JSON.
    ///
    /// - Returns: An array of `Result` objects representing the search results.
    func fetchPosts(word: String, dir: String) {
        
        guard let url = URL(string: "http://lexin.nada.kth.se/lexin/service?searchinfo=\(dir),swe_spa,\(word)&output=JSON") else {
            errorMje(mje: "Word not found")
            //errorMje(mje: LocalizedStringKey("wordnotfound"))
            //fatalError("Invalid URL")
            return
        }
        // Send a data task to the API to fetch the data
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // If there is an error during the data task, emit an error message
                print("Error fetching results: \(error.localizedDescription)")
                print(String(describing: error))
                errorMje(mje: "URL session error")
                //errorMje(mje: LocalizedStringKey("wordnotfound"))
                
                return
            }
            // Check if the response is vali
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                // If the response is not valid, emit an error message
                print("Invalid response")
                errorMje(mje: "Invalid response")
                
                return
            }
            
            do {
                // Parse the fetched data using a JSONDecoder and update the results
                let myresults = try JSONDecoder().decode(Words.self, from: data)
                DispatchQueue.main.async {
                    self.results = myresults.result
                    //print(myresults)
                    
                    errorMje(mje: "OK")
                    
                }
                
                
            } catch {
                // If there is an error during parsing, emit an error message
                print("Error decoding results: \(error.localizedDescription)")
                print(String(describing: error))
                
                errorMje(mje: "No word match")
                
                
            }
        }.resume()
        
        /**
         Emits an error message on the errorSubject.
         
         - Parameter mje: A `String` that represents the error message to be emitted.
         */
        func errorMje(mje: String) {
            
            DispatchQueue.main.async {
                self.errorSubject.send(mje)
            }
            
        }
        
    }
    
}
