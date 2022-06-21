//
//  RouteDetailViewModel.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import Foundation
import MetroTransitKit

final class RouteDetailViewModel: ObservableObject {
    private let metroTransitClient = MetroTransitClient()

    @Published var places = [Place]()
    @Published var selectedDirection = 0 {
        didSet {
            getStops()
        }
    }
    @Published var directions = [Direction]()
    @Published var route: Route

    init(route: Route) {
        self.route = route

        metroTransitClient.nexTrip.getDirections(routeId: route.routeId!) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    print(err)
                case .success(let directions):
                    self.directions = directions
                    self.selectedDirection = directions.first!.directionId
                    self.getStops()
                }
            }
        }
    }

    func getStops() {
        metroTransitClient.nexTrip.getStops(routeID: route.routeId!, directionID: selectedDirection) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let places):
                    self.places = places
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}
