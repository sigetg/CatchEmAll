//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by George Sigety on 3/12/23.
//

import SwiftUI

struct CreaturesListView: View {
    var creatures = ["pikachu", "snorlax", "squirtle", "bulbasaur"]
    var body: some View {
        NavigationStack {
            List(creatures, id: \.self) { creature in
                Text(creature)
                    .font(.title2)
            }
            .listStyle(.plain)
            .navigationTitle("Pokemon")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreaturesListView()
    }
}
