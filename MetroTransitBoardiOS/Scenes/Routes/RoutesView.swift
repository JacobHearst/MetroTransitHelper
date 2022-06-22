//
//  FavoritesView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import SwiftUI

struct RoutesView: View {
    @StateObject private var viewModel = RoutesViewModel()

    var body: some View {
        NavigationView() {
            VStack {
                SearchBar(text: $viewModel.routeSearchTerm)
                List(viewModel.filteredRoutes, id: \.routeId!) { route in
                    NavigationLink(route.routeLabel!, destination: RouteDetailView(route: route))
                }
            }.navigationTitle("All Routes")
        }
    }
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView()
    }
}
