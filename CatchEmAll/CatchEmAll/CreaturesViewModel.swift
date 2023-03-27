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
    @Published var isLooading = false
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        isLooading = true
        //convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: could not create a url from \(urlString)")
            isLooading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //try to decode JSON into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: could not decode returned JSON data")
                isLooading = false
                return
                
            }
            self.count = returned.count
            self.urlString = returned.next ?? ""
            self.creaturesArray = self.creaturesArray + returned.results
            isLooading = false
            
        } catch {
            isLooading = false
            print("😡 ERROR: could not use URL at \(urlString) to get data and response")
        }
    }
    func loadNextIfNeeded(creature: Creature) async {
        guard let lastCreature = creaturesArray.last else {
            return
        }
        if creature.id == lastCreature.id && urlString.hasPrefix("http") {
            Task {
                await getData()
            }
        }
    }
    
    func loadAll() async {
        guard urlString.hasPrefix("http") else {return}
        
        await getData() //get next page of data
        await loadAll()
    }
}
