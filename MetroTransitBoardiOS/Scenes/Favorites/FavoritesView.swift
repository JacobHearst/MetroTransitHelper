//
//  SavedStopsView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/17/22.
//

import SwiftUI
import MetroTransitKit

struct FavoritesView: View {
    @ObservedObject var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add a stop", text: $viewModel.addStopText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Image(systemName: "plus.circle")
                        .onTapGesture(perform: viewModel.addStop)
                }.padding()
                Text("Last updated: \(viewModel.lastUpdated)")
                    .font(.caption)
                favoritesList()
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text(viewModel.error!))
            }
            .navigationTitle("Saved Stops")
        }
    }

    @ViewBuilder func favoritesList() -> some View {
        if viewModel.nexTrips.keys.isEmpty {
            Text("No saved routes")
            Spacer()
        } else {
            List {
                ForEach(Array(viewModel.nexTrips.keys), id: \.self) { key in
                    let nexTrip = viewModel.nexTrips[key]!
                    NavigationLink(destination: StopDetailView(stopId: key, nexTrip: nexTrip),
                                   label: {
                        VStack(alignment: .leading) {
                            Text(nexTrip.stops!.first!.description!).truncationMode(.middle)
                            if let departures = viewModel.nexTrips[key]!.departures {
                                departurePills(departures)
                            } else {
                                Text("No Departures")
                            }
                        }
                    })
                }.onDelete(perform: viewModel.deleteStop)
            }.refreshable { viewModel.updateNexTrips() }
        }
    }

    @ViewBuilder func departurePills(_ departures: [Departure]) -> some View {
        HStack {
            ForEach(departures[0...2]) { departure in
                Text("\(departure.routeId!) \(departure.departureText!)")
                    .foregroundColor(.white)
                    .padding([.top, .bottom], 5)
                    .padding([.leading, .trailing], 10)
                    .background(
                        Capsule().foregroundColor(.blue)
                    )
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
