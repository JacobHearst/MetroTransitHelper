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
    @Published var nexTrip: NexTripResult?
    @Published var departures = [Departure]()

    @Published var stopNumber = ""

    @Published var routes = [Route]()
    @Published var routeSearchTerm = "" {
        didSet {
            guard !routeSearchTerm.isEmpty else {
                filteredRoutes = routes
                return
            }

            filteredRoutes = routes.filter { $0.routeLabel!.lowercased().contains(routeSearchTerm.lowercased()) }
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

            filteredPlaces = places.filter { $0.description!.lowercased().contains(placeSearchTerm.lowercased()) }
        }
    }
    @Published var placeCodeSelection = ""

    @Published var error: String? = nil

    init() {
        metroTransitClient.nexTrip.getRoutes { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    self.error = err.localizedDescription
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
        metroTransitClient.nexTrip.getDirections(routeId: routeId) { result in
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
                    self.error = err.localizedDescription
                }
            }
        }
    }

    func getPlaces(for routeId: String, direction: Int) {
        metroTransitClient.nexTrip.getStops(routeID: routeId, directionID: direction) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    self.error = err.localizedDescription
                case .success(let places):
                    self.places = places
                    self.filteredPlaces = places
                    self.placeCodeSelection = places.first!.placeCode!
                }
            }
        }
    }

    func getDepartures() {
        self.error = nil
        if departuresSourceType == 0 {
            getDeparturesByRoute()
        } else {
            getDeparturesByStop()
        }
    }

    func getDeparturesByRoute() {
        metroTransitClient.nexTrip.getNexTrip(routeID: routeSelection, directionID: directionSelection, placeCode: placeCodeSelection) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nexTripResult):
                    self.nexTrip = nexTripResult
                    self.departures = nexTripResult.departures ?? []
                case .failure(let err):
                    self.error = err.localizedDescription
                }
            }
        }
    }

    func getDeparturesByStop() {
        guard !stopNumber.isEmpty else {
            error = "Please enter a stop number"
            return
        }

        guard let stopId = Int(stopNumber) else {
            error = "Invalid stop number"
            return
        }

        metroTransitClient.nexTrip.getNexTrip(stopID: stopId) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let err):
                    self.error = err.localizedDescription
                case .success(let nexTripResult):
                    self.nexTrip = nexTripResult
                    self.departures = nexTripResult.departures ?? []
                }
            }
        }
    }

    func saveStop() {
        if departuresSourceType == 0,
           let stop = nexTrip?.stops?.first {
            UserDefaultsService.shared.addFavorite(stopId: stop.stopId)
        } else if let stopNumber = Int(self.stopNumber) {
            UserDefaultsService.shared.addFavorite(stopId: stopNumber)
        }
    }
}

extension DeparturesViewModel: DeparturesListDelegate {
    func refreshDepartures() {
        getDepartures()
    }
}
