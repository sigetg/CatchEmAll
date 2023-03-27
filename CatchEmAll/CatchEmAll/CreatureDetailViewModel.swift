//
//  CreatureDetailViewModel.swift
//  CatchEmAll
//
//  Created by George Sigety on 3/13/23.
//

import Foundation

@MainActor
class CreatureDetailViewModel: ObservableObject {
    
    private struct Returned: Codable { // VERY IMPORTANT: JSON values must be Codable
        var height: Double?
        var weight: Double?
        var sprites: Sprite
    }
    
    struct Sprite: Codable {
        var front_default: String?
        var other: Other
    }
    
    struct Other: Codable {
        var officialArtwork: OfficialArtwork
        
        enum CodingKeys: String, CodingKey {
            case officialArtwork = "official-artwork"
        }
    }
    
    struct OfficialArtwork: Codable {
        var front_default: String?
    }
    
    var urlString = ""
    @Published var height = 0.0
    @Published var weight = 0.0
    @Published var imageURL = ""
    
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
            self.height = returned.height ?? 0.0
            self.weight = returned.weight ?? 0.0
            self.imageURL = returned.sprites.other.officialArtwork.front_default ?? "N/A" //don't use empty string! it converts to a valid url and won't create an error
            
        } catch {
            print("😡 ERROR: could not use URL at \(urlString) to get data and response")
        }
    }
}
