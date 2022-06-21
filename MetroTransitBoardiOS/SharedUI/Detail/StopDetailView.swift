//
//  StopDetailView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/21/22.
//

import SwiftUI
import MetroTransitKit

struct StopDetailView: View {
    var stopId: Int
    var nexTrip: NexTripResult

    var body: some View {
        VStack {
            if let departures = nexTrip.departures {
                DeparturesListView(departures: departures)
            }
        }.navigationTitle("Departures")
    }
}

struct StopDetailView_Previews: PreviewProvider {
    static let mockNexTrip = NexTripResult(
        stops: [],
        alerts: [],
        departures: [])

    static var previews: some View {
        StopDetailView(stopId: 123, nexTrip: mockNexTrip)
    }
}
