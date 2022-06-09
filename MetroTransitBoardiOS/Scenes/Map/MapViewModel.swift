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

    @Published var error: String? = nil
    @Published var vehicles = [Vehicle]() {
        didSet {
            focusMap()
        }
    }

    private var routeId: String
    private var timer: Timer?
    private var tripId: String?
    private var stopId: String?

    init(routeId: String, tripId: String?, stopId: String?) {
        self.routeId = routeId
        self.tripId = tripId
        self.stopId = stopId

        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()

        getVehicles()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getVehicles), userInfo: nil, repeats: true)
    }

    @objc func getVehicles() {
        metroTransitClient.getVehicles(routeID: routeId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let vehicles):
                    guard let tripId = self.tripId else {
                        self.vehicles = vehicles
                        return
                    }

                    self.vehicles = vehicles.filter { $0.tripId == tripId }
                case .failure(let err):
                    self.error = err.localizedDescription
                }
            }
        }
    }

    func focusMap() {
        let vehicle = vehicles.count > 1 ? findCenterVehicle() : vehicles.first
        let deltas = vehicles.count > 1 ? getDeltas() : (latDelta: 0.005, lonDelta: 0.005)
        guard let vehicle = vehicle else {
            return
        }

        region = MKCoordinateRegion(
            center: vehicle.location,
            span: MKCoordinateSpan(latitudeDelta: deltas.latDelta, longitudeDelta: deltas.lonDelta)
        )
    }

    func getDeltas() -> (latDelta: Double, lonDelta: Double) {
        var minLat: Double = .infinity
        var maxLat: Double = 0

        var minLon: Double = .infinity
        var maxLon: Double = 0

        for location in vehicles.map({ $0.location }) {
            let currLat = abs(location.latitude)
            let currLon = abs(location.longitude)

            minLat = currLat < minLat ? currLat : minLat
            minLon = currLon < minLon ? currLon : minLon

            maxLat = currLat > maxLat ? currLat : maxLat
            maxLon = currLon > maxLon ? currLon : maxLon
        }

        let latDelta = abs(maxLat - minLat)
        let lonDelta = abs(maxLon - minLon)

        return (latDelta + 0.05, lonDelta + 0.05)
    }

    func findCenterVehicle() -> Vehicle? {
        let vehicleLocations = vehicles.map { $0.location }
        let center = calculateCenter(of: vehicleLocations)

        guard var closestVehicle = vehicles.first else {
            return nil
        }

        for vehicle in vehicles {
            let currVehicleLoc = CLLocation(latitude: vehicle.location.latitude, longitude: vehicle.location.longitude)
            let closestVehicleLoc = CLLocation(latitude: closestVehicle.location.latitude, longitude: closestVehicle.location.longitude)
            if currVehicleLoc.distance(from: center) < closestVehicleLoc.distance(from: center) {
                closestVehicle = vehicle
            }
        }

        return closestVehicle
    }

    func calculateCenter(of points: [CLLocationCoordinate2D]) -> CLLocation {
        var latAvg: CLLocationDegrees = 0
        var longAvg: CLLocationDegrees = 0

        for vehicle in vehicles {
            latAvg += vehicle.location.latitude
            longAvg += vehicle.location.longitude
        }

        latAvg /= Double(vehicles.count)
        longAvg /= Double(vehicles.count)

        return CLLocation(latitude: latAvg, longitude: longAvg)
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }
}
