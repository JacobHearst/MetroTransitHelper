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
            Task { await updateNexTrips() }
            self.timer = Timer(timeInterval: 60, target: self, selector: #selector(updateNexTrips), userInfo: nil, repeats: true)
        }
    }

    @objc func updateNexTrips() async {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        lastUpdated = formatter.string(from: Date())

        for stopId in self.favoriteStopIds {
            do {
                let nexTrip = try await client.nexTrip.getNexTrip(stopID: stopId)
                DispatchQueue.main.async {
                    self.nexTrips[stopId] = nexTrip
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.showError = true
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

        Task {
            do {
                let nexTrip = try await client.nexTrip.getNexTrip(stopID: stopId)
                DispatchQueue.main.async {
                    self.nexTrips[stopId] = nexTrip
                    self.addStopText = ""

                    UserDefaultsService.shared.addFavorite(stopId: stopId)
                    self.favoriteStopIds = UserDefaultsService.shared.currentFavorites
                }
            } catch {
                DispatchQueue.main.async {
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
