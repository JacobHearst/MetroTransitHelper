//
//  Vehicle.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import MetroTransitKit
import CoreLocation

extension Vehicle: Identifiable {
    public var id: UUID { UUID() }
    public var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: CLLocationDegrees(latitude),
            longitude: CLLocationDegrees(longitude)
        )
    }
}
