//
//  FavoritesViewModel.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import Foundation
import MetroTransitKit

final class RoutesViewModel: ObservableObject {
    @Published var routes = [Route]()

    init() {
        MetroTransitClient().nexTrip.getRoutes { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let routes):
                    self.routes = routes
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}
