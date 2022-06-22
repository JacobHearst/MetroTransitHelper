//
//  StopDetailViewModel.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/22/22.
//

import Foundation
import MetroTransitKit

final class StopDetailViewModel: ObservableObject {
    private var stopId: Int
    private let client = MetroTransitClient()

    @Published var nexTrip: NexTripResult?

    init(stopId: Int) {
        self.stopId = stopId
        Task { await refreshNexTrip() }
    }

    func refreshNexTrip() async {
        do {
            let nexTrip = try await client.nexTrip.getNexTrip(stopID: stopId)
            DispatchQueue.main.async {
                self.nexTrip = nexTrip
            }
        } catch {
            print(error)
        }
    }
}

extension StopDetailViewModel: DeparturesListDelegate {
    func refreshDepartures() {
        Task { await refreshNexTrip() }
    }
}
