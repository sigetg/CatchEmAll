//
//  Creature.swift
//  CatchEmAll
//
//  Created by George Sigety on 3/13/23.
//

import Foundation

struct Creature: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String //url for detail on pokemon
    
    enum CodingKeys: CodingKey {
        case name, url
    }
}
