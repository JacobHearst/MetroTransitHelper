//
//  StopDetailView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/21/22.
//

import SwiftUI
import MetroTransitKit

struct StopDetailView: View {
    @StateObject private var viewModel: StopDetailViewModel

    init(stopId: Int) {
        self._viewModel = .init(wrappedValue: StopDetailViewModel(stopId: stopId))
    }

    var body: some View {
        VStack {
            if let departures = viewModel.nexTrip?.departures {
                DeparturesListView(delegate: viewModel, departures: departures)
            }
        }.navigationTitle("Departures")
    }
}

struct StopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StopDetailView(stopId: 123)
    }
}
