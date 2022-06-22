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
        refreshNexTrip()
    }

    func refreshNexTrip() {
        client.nexTrip.getNexTrip(stopID: stopId) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let nexTrip):
                DispatchQueue.main.async {
                    self.nexTrip = nexTrip
                }
            }
        }
    }
}

extension StopDetailViewModel: DeparturesListDelegate {
    func refreshDepartures() {
        refreshNexTrip()
    }
}
