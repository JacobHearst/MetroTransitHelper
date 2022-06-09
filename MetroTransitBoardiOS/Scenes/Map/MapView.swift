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
    @ObservedObject private var viewModel: MapViewModel

    init(routeId: String, tripId: String? = nil, stopId: String? = nil) {
        self.viewModel = MapViewModel(routeId: routeId, tripId: tripId, stopId: stopId)
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
        }
    }
}
