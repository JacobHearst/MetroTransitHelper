//
//  AddFavoriteViewModel.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/17/22.
//

import Foundation
import MetroTransitKit

final class AddFavoriteViewModel: ObservableObject {
    @Published var stopSelection = ""
    @Published var stopSearchTerm = "" {
        didSet {
            guard !stopSearchTerm.isEmpty else {
                filteredStops = stops
                return
            }

            filteredStops = stops.filter { $0.description!.contains(stopSearchTerm) }
        }
    }
    @Published var filteredStops = [Stop]()
    @Published var stops = [Stop]()
}
