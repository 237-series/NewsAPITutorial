//
//  RequestAPI.swift
//  NewsAPITutorial
//
//  Created by sglee237 on 2023/03/14.
//

import Foundation

struct Results: Decodable {
    let articles: [Article]
}

struct Article: Decodable, Hashable {
    let title: String
    let url: String
    let urlToImage: String?
}

class RequestAPI: ObservableObject {
    static let shared = RequestAPI()
    private init() {}
    @Published var posts = [Article]()
    
    private let apiKey = ""
    
    func fetchData() {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=\(apiKey)") else {
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                self.posts = []
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(Results.self, from: data)
                DispatchQueue.main.async {
                    self.posts = apiResponse.articles
                }
            } catch {
                print("Decoding error")
            }
        }
        task.resume()
    }
}
