//
//  ContentView.swift
//  MetroTransitBoard
//
//  Created by Jacob Hearst on 6/3/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DeparturesView().tabItem {
                Image(systemName: "clock")
                Text("Departures")
            }
            MapView().tabItem {
                Image(systemName: "map")
                Text("Map")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
