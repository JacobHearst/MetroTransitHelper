//
//  FavoriteAddView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/17/22.
//

import SwiftUI

struct AddFavoriteView: View {
    @ObservedObject var viewModel = AddFavoriteViewModel()

    var body: some View {
        VStack {
            Text("Pick a stop")
            Picker("Stop", selection: $viewModel.stopSelection) {
                SearchBar(text: $viewModel.stopSearchTerm)
                ForEach(viewModel.filteredStops, id: \.stopId) { stop in
                    Text(stop.description!).tag(stop.stopId)
                }
            }
        }
    }
}

struct FavoriteAddView_Previews: PreviewProvider {
    static var previews: some View {
        AddFavoriteView()
    }
}
