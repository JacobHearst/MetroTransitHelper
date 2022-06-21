//
//  SavedStopsView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/17/22.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel = FavoritesViewModel()

    var body: some View {
        VStack {
            HStack {
                TextField("Add a stop", text: $viewModel.addStopText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Image(systemName: "plus.circle")
                    .onTapGesture(perform: viewModel.addStop)
            }.padding()
            Text("Last updated: \(viewModel.lastUpdated)")
            favoritesList()
        }.alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.error!))
        }
    }

    @ViewBuilder func favoritesList() -> some View {
        List(Array(viewModel.nexTrip.keys), id: \.self) { key in
            Section("\(viewModel.nexTrip[key]!.stops!.first!.description!) (\(String(key)))") {
                if let departures = viewModel.nexTrip[key]!.departures {
                    ForEach(departures[0...2]) { departure in
                        Text("\(departure.routeId!) \(departure.departureText!)")
                    }
                } else {
                    Text("No Departures")
                }
            }
        }.refreshable { viewModel.updateNexTrips() }
    }
}

struct SavedStopsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
