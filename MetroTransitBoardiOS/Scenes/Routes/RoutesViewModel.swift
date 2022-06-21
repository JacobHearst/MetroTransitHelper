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
    @Published var filteredRoutes = [Route]()
    @Published var routeSearchTerm = "" {
        didSet {
            guard !routeSearchTerm.isEmpty else {
                filteredRoutes = routes
                return
            }

            filteredRoutes = routes.filter { $0.routeLabel!.lowercased().contains(routeSearchTerm.lowercased()) }
        }
    }

    init() {
        MetroTransitClient().nexTrip.getRoutes { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let routes):
                    self.routes = routes
                    self.filteredRoutes = routes
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}
