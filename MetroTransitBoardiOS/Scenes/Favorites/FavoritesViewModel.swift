//
//  FavoritesViewModel.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/17/22.
//

import Foundation
import MetroTransitKit

final class FavoritesViewModel: ObservableObject {
    @Published var favoriteStops = [Stop]()
    @Published var showAddFavoritePopover = false

    init() {
        if let favorites = UserDefaults.standard.array(forKey: "favoriteStops") as? [Stop] {
            self.favoriteStops = favorites
        }
    }
}
