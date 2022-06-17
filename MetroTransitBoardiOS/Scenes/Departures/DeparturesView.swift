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
                    Section(header: Text("Options")) {
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
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding(10)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Spacer()
                        }
                    }

                    if let err = viewModel.error {
                        Text(err)
                            .foregroundColor(.red)
                    }

                    Section(header: Text("Results")) {
                        DeparturesListView(departures: viewModel.departures)
                    }
                }.navigationTitle("Find Departures")
            }
        }
    }

    func makeRouteSelector() -> some View {
        Group {
            if viewModel.routes.isEmpty {
                Text("Loading Routes...")
            } else {
                Picker("Route", selection: $viewModel.routeSelection) {
                    SearchBar(text: $viewModel.routeSearchTerm)
                        .navigationTitle("Select a Route")
                    ForEach(viewModel.filteredRoutes, id: \.routeId!) { route in
                        Text(route.routeLabel!).tag(route.routeId!)
                    }
                }
            }

            if viewModel.directions.isEmpty {
                Text("Loading directions...")
            } else {
                Picker("Direction", selection: $viewModel.directionSelection) {
                    ForEach(viewModel.directions, id: \.directionId) { direction in
                        Text(direction.directionName ?? "No name")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }

            if viewModel.places.isEmpty {
                Text("Loading stops...")
            } else {
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
}

struct DeparturesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {

            DeparturesView()
                .previewInterfaceOrientation(.portraitUpsideDown)
        }
    }
}
