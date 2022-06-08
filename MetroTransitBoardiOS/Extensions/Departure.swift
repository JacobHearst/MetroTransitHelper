//
//  Departure+Label.swift
//  MetroTransitBoard
//
//  Created by Jacob Hearst on 6/6/22.
//

import MetroTransitKit
import Foundation

extension Departure: Identifiable {
    public var id: UUID { UUID() }

    var label: String {
        guard let shortName = routeShortName,
              let departureText = departureText else {
            return "Error"
        }

        return "\(shortName): \(departureText)"
    }
}
