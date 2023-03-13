//
//  CreaturesViewModel.swift
//  CatchEmAll
//
//  Created by George Sigety on 3/13/23.
//

import Foundation

@MainActor
class CreaturesViewModel: ObservableObject {
    
    private struct Returned: Codable { // VERY IMPORTANT: JSON values must be Codable
        var count: Int
        var next: String?
        var results: [Creature]
    }
    

    
    @Published var urlString = "https://pokeapi.co/api/v2/pokemon/"
    @Published var count = 0
    @Published var creaturesArray: [Creature] = []
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        //convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: could not create a url from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //try to decode JSON into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: could not decode returned JSON data")
                return
                
            }
            self.count = returned.count
            self.urlString = returned.next ?? ""
            self.creaturesArray = self.creaturesArray + returned.results
            
        } catch {
            print("😡 ERROR: could not use URL at \(urlString) to get data and response")
        }
    }
}
