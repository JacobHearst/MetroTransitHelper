//
//  FavoritesViewModel.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/17/22.
//

import Foundation
import MetroTransitKit

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteStopIds: [Int]
    private var client = MetroTransitClient()
    private var timer: Timer?

    @Published var nexTrips = [Int: NexTripResult]()
    @Published var addStopText = ""
    @Published var error: String?
    @Published var showError = false
    @Published var lastUpdated = ""

    init() {
        favoriteStopIds = UserDefaultsService.shared.currentFavorites
        if !favoriteStopIds.isEmpty {
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
                        self.nexTrips[stopId] = nexTrip
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
                    self.nexTrips[stopId] = nexTrip
                    self.addStopText = ""

                    UserDefaultsService.shared.addFavorite(stopId: stopId)
                    self.favoriteStopIds = UserDefaultsService.shared.currentFavorites
                case .failure(let error):
                    self.error = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }

    func deleteStop(_ offset: IndexSet) {
        for offset in Array(offset) {
            let stopId = favoriteStopIds[offset]
            nexTrips.removeValue(forKey: stopId)
            UserDefaultsService.shared.removeFavorite(stopId: stopId)
            self.favoriteStopIds = UserDefaultsService.shared.currentFavorites
        }
    }

    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
}
