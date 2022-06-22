//
//  DeparturesListView.swift
//  MetroTransitBoard
//
//  Created by Jacob Hearst on 6/3/22.
//

import SwiftUI
import MetroTransitKit

protocol DeparturesListDelegate {
    func refreshDepartures() -> Void
}

struct DeparturesListView: View {
    var delegate: DeparturesListDelegate
    var departures: [Departure]

    var body: some View {
        List(departures) { departure in
            NavigationLink(destination: MapView(routeId: departure.routeId!, title: departure.label, tripId: departure.tripId), label: {
                HStack {
                    Text(departure.label)
                    Spacer()
                    Text(departure.departureText ?? "No text")
                        .padding([.leading, .trailing])
                        .foregroundColor(.white)
                        .background {
                            Capsule().foregroundColor(.blue)
                        }
                }
            })
        }.refreshable { delegate.refreshDepartures() }
    }
}

struct DeparturesListDelegate_Previews: DeparturesListDelegate {
    func refreshDepartures() {}
}

struct DeparturesListView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesListView(delegate: DeparturesListDelegate_Previews(), departures: [])
    }
}
