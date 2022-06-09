//
//  FavoritesView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import SwiftUI

struct RoutesView: View {
    @ObservedObject private var viewModel = RoutesViewModel()

    var body: some View {
        NavigationView() {
            List(viewModel.routes, id: \.routeId!) { route in
                NavigationLink(route.routeLabel!, destination: RouteDetailView(route: route))
            }.navigationTitle("All Routes")
        }
    }
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView()
    }
}