//
//  RouteDetailView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import SwiftUI
import MetroTransitKit

struct RouteDetailView: View {
    @ObservedObject private var viewModel: RouteDetailViewModel

    init(route: Route) {
        self.viewModel = RouteDetailViewModel(route: route)
    }

    var body: some View {
        VStack {
            Picker("Direction", selection: $viewModel.selectedDirection) {
                ForEach(viewModel.directions, id: \.directionId) { direction in
                    Text(direction.directionName!)
                        .tag(direction.directionId)
                }
            }.pickerStyle(SegmentedPickerStyle())

            MapView(routeId: viewModel.route.routeId!)

            List(viewModel.places, id: \.placeCode!) { place in
                Text(place.description!)
            }
        }.navigationTitle(viewModel.route.routeLabel!)
    }
}
