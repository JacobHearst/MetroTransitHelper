//
//  DeparturesView.swift
//  MetroTransitBoard
//
//  Created by Jacob Hearst on 6/3/22.
//

import SwiftUI

struct DeparturesView: View {
    @ObservedObject private var viewModel: DeparturesViewModel

    init() {
        viewModel = DeparturesViewModel()
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Picker("By", selection: $viewModel.departuresSourceType) {
                        Text("Route").tag(0)
                        Text("Stop").tag(1)
                    }.pickerStyle(SegmentedPickerStyle())

                    if viewModel.departuresSourceType == 0 {
                        makeRouteSelector()
                    } else {
                        TextField("Enter Stop Number", text: $viewModel.stopNumber)
                    }

                    HStack {
                        Spacer()
                        Button("Go", action: viewModel.getDepartures)
                            .buttonStyle(BorderedProminentButtonStyle())
                        Spacer()
                    }
                }.navigationTitle("Find Departures")

                DeparturesListView(departures: viewModel.departures)
            }
        }
    }

    func makeRouteSelector() -> some View {
        Group {
            Picker("Route", selection: $viewModel.routeSelection) {
                SearchBar(text: $viewModel.routeSearchTerm)
                    .navigationTitle("Select a Route")
                ForEach(viewModel.filteredRoutes, id: \.routeId!) { route in
                    Text(route.routeLabel!).tag(route.routeId!)
                }
            }

            Picker("Direction", selection: $viewModel.directionSelection) {
                ForEach(viewModel.directions, id: \.directionId) { direction in
                    Text(direction.directionName ?? "No name")
                }
            }.pickerStyle(SegmentedPickerStyle())

            Picker("Stop", selection: $viewModel.placeCodeSelection) {
                SearchBar(text: $viewModel.placeSearchTerm)
                    .navigationTitle("Select a Stop")
                ForEach(viewModel.filteredPlaces, id: \.placeCode!) { place in
                    Text(place.description!)
                }
            }
        }
    }
}

struct DeparturesView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesView()
    }
}
