//
//  DeparturesViewModel.swift
//  MetroTransitBoard
//
//  Created by Jacob Hearst on 6/3/22.
//

import Combine
import Foundation
import MetroTransitKit

final class DeparturesViewModel: ObservableObject {
    private let metroTransitClient = MetroTransitClient()

    @Published var routeSelection = "" {
        didSet {
            getDirections(for: routeSelection)
        }
    }
    @Published var departuresSourceType = 0
    @Published var departures = [Departure]()

    @Published var stopNumber = ""

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

    @Published var directions = [Direction]()
    @Published var directionSelection = 0 {
        didSet {
            getPlaces(for: routeSelection, direction: directionSelection)
        }
    }

    @Published var places = [Place]()
    @Published var filteredPlaces = [Place]()
    @Published var placeSearchTerm = "" {
        didSet {
            guard !placeSearchTerm.isEmpty else {
                filteredPlaces = places
                return
            }

            filteredPlaces = places.filter { $0.description!.contains(placeSearchTerm) }
        }
    }
    @Published var placeCodeSelection = ""

    init() {
        metroTransitClient.getRoutes { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    print(err)
                case .success(let routes):
                    self.routes = routes
                    self.filteredRoutes = routes
                    guard let firstRoute = routes.first else {
                        print("No routes returned")
                        return
                    }

                    self.routeSelection = firstRoute.routeId ?? ""
                    self.getDirections(for: firstRoute.routeId!)
                }
            }
        }
    }

    func getDirections(for routeId: String) {
        metroTransitClient.getDirections(routeID: routeId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let directions):
                    self.directions = directions
                    guard let firstDirection = directions.first else {
                        print("No directions for route id: \(routeId)")
                        return
                    }

                    self.getPlaces(for: routeId, direction: firstDirection.directionId)
                case .failure(let err):
                    print(err)
                }
            }
        }
    }

    func getPlaces(for routeId: String, direction: Int) {
        metroTransitClient.getStops(routeID: routeId, directionID: direction) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    print(err)
                case .success(let places):
                    self.places = places
                    self.filteredPlaces = places
                    self.placeCodeSelection = places.first!.placeCode!
                }
            }
        }
    }

    func getDepartures() {
        if departuresSourceType == 0 {
            getDeparturesByRoute()
        } else {
            getDeparturesByStop()
        }
    }

    func getDeparturesByRoute() {
        metroTransitClient.getNexTrip(routeID: routeSelection, directionID: directionSelection, placeCode: placeCodeSelection) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nexTripResult):
                    self.departures = nexTripResult.departures ?? []
                case .failure(let err):
                    print(err)
                }
            }
        }
    }

    func getDeparturesByStop() {
        guard let stopId = Int(stopNumber) else {
            print("Stop id '\(stopNumber)' couldn't be cast to an int")
            return
        }

        metroTransitClient.getNexTrip(stopID: stopId) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    print(err)
                case .success(let nexTripResult):
                    self.departures = nexTripResult.departures ?? []
                }
            }
        }
    }
}
