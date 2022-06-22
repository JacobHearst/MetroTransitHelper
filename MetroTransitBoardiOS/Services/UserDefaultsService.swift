//
//  UserDefaultsService.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/22/22.
//

import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()

    private enum DefaultsKey: String {
        case favoriteStops
    }

    private let defaults = UserDefaults.standard

    var currentFavorites: [Int] {
        (defaults.array(forKey: DefaultsKey.favoriteStops.rawValue) as? [Int]) ?? [Int]()
    }

    func addFavorite(stopId: Int) {
        var newFavorites = currentFavorites
        guard !newFavorites.contains(stopId) else { return }

        newFavorites.append(stopId)
        defaults.setValue(newFavorites, forKey: DefaultsKey.favoriteStops.rawValue)
    }

    func removeFavorite(stopId: Int) {
        guard let index = currentFavorites.firstIndex(of: stopId) else { return }
        var newFavorites = currentFavorites
        newFavorites.remove(at: index)
        defaults.setValue(newFavorites, forKey: DefaultsKey.favoriteStops.rawValue)
    }
}
