//
//  ContentView.swift
//  MetroTransitBoard
//
//  Created by Jacob Hearst on 6/3/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 2
    var body: some View {
        TabView(selection: $selectedTab) {
            DeparturesView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("Departures")
                }
                .tag(0)
            Text("Favorites")
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(1)
            RoutesView()
                .tabItem {
                    Image(systemName: "bus")
                    Text("Routes")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
