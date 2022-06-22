//
//  MapView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import SwiftUI
import MapKit
import MetroTransitKit

struct MapView: View {
    @StateObject private var viewModel: MapViewModel
    private var title: String

    init(routeId: String, title: String, tripId: String? = nil, stopId: String? = nil) {
        self._viewModel = .init(wrappedValue: MapViewModel(routeId: routeId, tripId: tripId, stopId: stopId))
        self.title = title
    }

    var body: some View {
        VStack {
            if let err = viewModel.error {
                Text(err)
            }
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.vehicles) { item in
                MapAnnotation(coordinate: item.location) {
                    VehicleMapAnnotation()
                }
            }
        }.navigationTitle(title)
    }
}
