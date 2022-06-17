//
//  SavedStopsView.swift
//  MetroTransitBoardiOS
//
//  Created by Jacob Hearst on 6/17/22.
//

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel = FavoritesViewModel()

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "plus.circle")
                    .onTapGesture{ viewModel.showAddFavoritePopover.toggle() }
                    .popover(isPresented: $viewModel.showAddFavoritePopover, content: { AddFavoriteView() })
            }
            
        }
    }
}

struct SavedStopsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
