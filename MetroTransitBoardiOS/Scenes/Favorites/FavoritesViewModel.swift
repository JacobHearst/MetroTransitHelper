//
//  FavoritesViewModel.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/17/22.
//

import Foundation
import MetroTransitKit

final class FavoritesViewModel: ObservableObject {
    private var favoriteStopIds = [Int]()
    private var client = MetroTransitClient()
    private var timer: Timer?

    @Published var nexTrip = [Int: NexTripResult]()
    @Published var addStopText = ""
    @Published var error: String?
    @Published var showError = false
    @Published var lastUpdated = ""

    init() {
        if let favorites = UserDefaults.standard.array(forKey: "favoriteStops") as? [Int] {
            self.favoriteStopIds = favorites
            updateNexTrips()
            self.timer = Timer(timeInterval: 60, target: self, selector: #selector(updateNexTrips), userInfo: nil, repeats: true)
        }
    }

    @objc func updateNexTrips() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        lastUpdated = formatter.string(from: Date())

        for stopId in self.favoriteStopIds {
            client.nexTrip.getNexTrip(stopID: stopId) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nexTrip):
                        self.nexTrip[stopId] = nexTrip
                    case .failure(let error):
                        self.error = error.localizedDescription
                        self.showError = true
                    }
                }
            }
        }
    }

    func addStop() {
        showError = false

        guard let stopId = Int(addStopText) else {
            error = "Invalid stop id \(addStopText)"
            showError = true
            return
        }

        client.nexTrip.getNexTrip(stopID: stopId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nexTrip):
                    self.nexTrip[stopId] = nexTrip
                    self.favoriteStopIds.append(stopId)
                    UserDefaults.standard.setValue(self.favoriteStopIds, forKey: "favoriteStops")
                case .failure(let error):
                    self.error = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }

    func getDepartureOverviewText(_ departuresList: [Departure]?) -> String {
        guard let departuresList = departuresList else {
            return "No departures"
        }

        return departuresList[0...3].map { "\($0.routeId!) in \($0.departureText!)" }.joined(separator: " // ")
    }

    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
}
