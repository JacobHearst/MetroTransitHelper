//
//  RouteDetailView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import SwiftUI
import MetroTransitKit

struct RouteDetailView: View {
    @StateObject private var viewModel: RouteDetailViewModel

    init(route: Route) {
        self._viewModel = .init(wrappedValue: RouteDetailViewModel(route: route))
    }

    var body: some View {
        VStack {
            MapView(routeId: viewModel.route.routeId!, title: viewModel.route.routeLabel!)

            Picker("Direction", selection: $viewModel.selectedDirection) {
                ForEach(viewModel.directions, id: \.directionId) { direction in
                    Text(direction.directionName!)
                        .tag(direction.directionId)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.leading, .trailing])

            List(viewModel.places, id: \.placeCode!) { place in
                Text(place.description!)
            }
        }.navigationTitle(viewModel.route.routeLabel!)
    }
}
