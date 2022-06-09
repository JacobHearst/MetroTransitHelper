//
//  VehicleMapAnnotation.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/8/22.
//

import SwiftUI
import MapKit

struct VehicleMapAnnotation: View {
    var body: some View {
        Image(systemName: "bus")
            .background(.white)
    }
}

struct VehicleMapAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        VehicleMapAnnotation()
    }
}
