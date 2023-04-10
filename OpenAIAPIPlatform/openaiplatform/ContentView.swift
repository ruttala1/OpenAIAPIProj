//
//  ContentView.swift
//  openaiplatform
//
//  Created by Dhruv Ruttala on 4/9/23.
//

import SwiftUI

struct ContentView: View {
    @State private var prompt: String = ""
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: SentimentAnalysisView()) {
                    Text("Enter Sentiment Analysis")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(1000)
                }

                                NavigationLink(destination: SentenceCompletionView()) {
                    Text("Enter Sentence Completer")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(1000)
                }
                                Spacer()
                VStack(alignment: .center) {
                    TextField("Type what you want to display", text: $prompt, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("Go"){
                        isLoading = true
                        Task{
                            do {
                                let response = try await DallEImageGenerator.shared.generateImage(withPrompt: prompt, apiKey: Secrets.apiKey)
                                
                                if let url = response.data.map(\.url).first{
                                    let (data, _) = try await URLSession.shared.data(from: url)
                                    image = UIImage(data: data)
                                    isLoading = false
                                }
                            } catch {
                                print(error)
                                isLoading = false
                                
                            }
                        }
                    }.cornerRadius(1000)
                        .buttonStyle(.borderedProminent).foregroundColor(.black)
                    
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 256, height: 256)
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 256, height: 256)
                            .overlay {
                                if isLoading {
                                    VStack {
                                        ProgressView()
                                        Text("Generating image.")
                                    }
                                }
                            }
                    }
                }
                .padding([.top, .bottom, .trailing])

                
               


               
            }
            .padding()
        }
    }
}

    
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}






