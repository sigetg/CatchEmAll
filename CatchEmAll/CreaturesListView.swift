//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by George Sigety on 3/12/23.
//

import SwiftUI

struct CreaturesListView: View {
    @StateObject var creaturesVM = CreaturesViewModel()
    var body: some View {
        NavigationStack {
            List(0..<creaturesVM.creaturesArray.count, id: \.self) { index in
                LazyVStack {
                    NavigationLink {
                        DetailView(creature: creaturesVM.creaturesArray[index])
                    } label: {
                        Text("\(index+1). \(creaturesVM.creaturesArray[index].name.capitalized)")
                            .font(.title2)
                    }
                }
                .onAppear {
                    if let lastCreature = creaturesVM.creaturesArray.last {
                        if creaturesVM.creaturesArray[index].name == lastCreature.name && creaturesVM.urlString.hasPrefix("http") {
                            Task {
                                await creaturesVM.getData()
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Pokemon")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Text("\(creaturesVM.creaturesArray.count) of \(creaturesVM.count)")
                }
            }
        }
        .task {
            await creaturesVM.getData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreaturesListView()
    }
}
