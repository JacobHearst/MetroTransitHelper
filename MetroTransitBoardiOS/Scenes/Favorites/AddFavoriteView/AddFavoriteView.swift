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
        TextField("Enter stop number", text: $viewModel.stopSearchTerm)
    }
}

struct FavoriteAddView_Previews: PreviewProvider {
    static var previews: some View {
        AddFavoriteView()
    }
}
