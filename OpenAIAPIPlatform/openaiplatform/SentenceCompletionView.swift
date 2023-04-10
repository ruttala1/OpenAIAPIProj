//
//  SentenceCompletionView.swift
//  openaiplatform
//
//  Created by Dhruv Ruttala on 4/9/23.
//

import SwiftUI

struct SentenceCompletionView: View {
    @State private var inputText: String = ""
    @State private var outputText: String = ""
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            TextField("Enter an incomplete sentence", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Button("Complete") {
                isLoading = true
                Task {
                    do {
                        
                        outputText = try await completeSentence(text: inputText, apiKey: Secrets.apiKey)
                    } catch {
                        print(error)
                    }
                    isLoading = false
                }
            }
            .padding(.vertical)
            .disabled(isLoading).foregroundColor(.white).frame(width: 100, height: 100).background(.black).cornerRadius(100)
            
            if isLoading {
                ProgressView()
            } else {
                Text(outputText)
                
            }
        }
        .padding()
    }
    
    func completeSentence(text: String, apiKey: String) async throws -> String {
        let completionsURL = URL(string: "https://api.openai.com/v1/completions")!
        
        let parameters: [String: Any] = [
            "model": "text-davinci-002",
            "prompt": "\(text)",
            "temperature": 0.7,
            "max_tokens": 50,
            "n": 1
            
        ]
        let data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: completionsURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (response, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(CompletionResponse.self, from: response)
        
        return result.choices.first?.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
    }
    
}

struct CompletionResponse: Codable {
    struct Choice: Codable {
        let text: String
    }
    
    let choices: [Choice]
}


struct SentenceCompletionView_Previews: PreviewProvider {
    static var previews: some View {
        SentenceCompletionView()
    }
}
