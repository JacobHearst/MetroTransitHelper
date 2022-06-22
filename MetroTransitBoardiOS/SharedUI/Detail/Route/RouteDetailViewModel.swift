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
            Task { await getPlaces() }
        }
    }
    @Published var directions = [Direction]()
    @Published var route: Route

    init(route: Route) {
        self.route = route

        Task {
            do {
                let directions = try await metroTransitClient.nexTrip.getDirections(routeId: route.routeId!)
                DispatchQueue.main.async {
                    self.directions = directions
                    self.selectedDirection = directions.first!.directionId
                }

                await getPlaces()
            } catch {
                print(error)
            }
        }
    }

    func getPlaces() async {
        do {
            let places = try await metroTransitClient.nexTrip.getStops(routeID: route.routeId!, directionID: selectedDirection)
            DispatchQueue.main.async {
                self.places = places
            }
        } catch {
            print(error)
        }
    }
}
