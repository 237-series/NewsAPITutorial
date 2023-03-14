//
//  ContentView.swift
//  NewsAPITutorial
//
//  Created by sglee237 on 2023/03/14.
//

import SwiftUI

struct URLImage: View {
    let urlString: String?
    @State var data: Data?
    
    var body: some View {
        VStack {
            
            if let data = data, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 70)
                    .background(.white)
            } else {
//                Image("")
//                    .frame(width: 130, height: 70)
//                    .background(.gray)
                    
            }
        }.onAppear(perform: {
            fetchImageData()
        })
    }
    
    private func fetchImageData() {
        guard let urlString = urlString else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, reponse, err in
            self.data = data
        }
        task.resume()
    }
}

struct ContentView: View {
    @StateObject private var network = RequestAPI.shared
    
    var body: some View {
        NavigationView {
            List {
                ForEach(network.posts, id: \.self) { result in
                    //Text(result.title)
                    HStack {
                        URLImage(urlString: result.urlToImage)
                        Text(result.title)
                            .bold()
                    }
                }
            }
            .navigationTitle("뉴스 둘러보기")
        }.onAppear(perform: {
            network.fetchData()
        })
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
