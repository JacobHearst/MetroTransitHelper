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
            Task { await getDirections(for: routeSelection) }
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
            Task { await getPlaces(for: routeSelection, direction: directionSelection) }
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
        Task {
            do {
                let routes = try await metroTransitClient.nexTrip.getRoutes()
                DispatchQueue.main.async {
                    self.routes = routes
                    self.filteredRoutes = routes
                }

                guard let firstRoute = routes.first else {
                    print("No routes returned")
                    return
                }

                DispatchQueue.main.async {
                    self.routeSelection = firstRoute.routeId ?? ""
                }

                await getDirections(for: firstRoute.routeId!)
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }

    func getDirections(for routeId: String) async {
        do {
            let directions = try await metroTransitClient.nexTrip.getDirections(routeId: routeId)
            DispatchQueue.main.async {
                self.directions = directions
            }

            guard let firstDirection = directions.first else {
                print("No directions for route id: \(routeId)")
                return
            }

            await getPlaces(for: routeId, direction: firstDirection.directionId)
        } catch {
            self.error = error.localizedDescription
        }
    }

    func getPlaces(for routeId: String, direction: Int) async {
        do {
            let places = try await metroTransitClient.nexTrip.getStops(routeID: routeId, directionID: direction)
            DispatchQueue.main.async {
                self.places = places
                self.filteredPlaces = places
                self.placeCodeSelection = places.first!.placeCode!
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
            }
        }
    }

    func getDepartures() {
        self.error = nil
        Task {
            if departuresSourceType == 0 {
                await getDeparturesByRoute()
            } else {
                await getDeparturesByStop()
            }
        }
    }

    func getDeparturesByRoute() async {
        do {
            let nexTripResult = try await metroTransitClient.nexTrip.getNexTrip(routeID: routeSelection, directionID: directionSelection, placeCode: placeCodeSelection)
            DispatchQueue.main.async {
                self.nexTrip = nexTripResult
                self.departures = nexTripResult.departures ?? []
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
            }
        }
    }

    func getDeparturesByStop() async {
        guard !stopNumber.isEmpty else {
            error = "Please enter a stop number"
            return
        }

        guard let stopId = Int(stopNumber) else {
            error = "Invalid stop number"
            return
        }

        do {
            let nexTripResult = try await metroTransitClient.nexTrip.getNexTrip(stopID: stopId)
            DispatchQueue.main.async {
                self.nexTrip = nexTripResult
                self.departures = nexTripResult.departures ?? []
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
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
