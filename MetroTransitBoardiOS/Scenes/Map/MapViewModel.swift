//
//  MapViewModel.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import Foundation
import MapKit
import MetroTransitKit

final class MapViewModel: ObservableObject {
    private let metroTransitClient = MetroTransitClient()

    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 44.9693031, longitude: -93.2367808),
        span: MKCoordinateSpan(latitudeDelta: 0.75, longitudeDelta: 0.75)
    )

    @Published var routes = [Route]()
    @Published var routeSearchTerm = "" {
        didSet {
            guard !routeSearchTerm.isEmpty else {
                filteredRoutes = routes
                return
            }

            filteredRoutes = routes.filter { $0.routeLabel!.contains(routeSearchTerm) }
        }
    }
    @Published var filteredRoutes = [Route]()
    @Published var routeSelection = ""
}
