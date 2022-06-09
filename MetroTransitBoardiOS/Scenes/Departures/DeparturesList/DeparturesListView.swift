//
//  DeparturesListView.swift
//  MetroTransitBoard
//
//  Created by Jacob Hearst on 6/3/22.
//

import SwiftUI
import MetroTransitKit

struct DeparturesListView: View {
    var departures: [Departure]

    var body: some View {
        List(departures) { departure in
            NavigationLink(destination: MapView(routeId: departure.routeId!, tripId: departure.tripId), label: {
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
        }
    }
}

struct DeparturesListView_Previews: PreviewProvider {
    static var previews: some View {
        DeparturesListView(departures: [])
    }
}
