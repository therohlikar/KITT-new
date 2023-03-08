//
//  FavoritesView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var fvm: FilterViewModel
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isFavorited == true")) var favorites: FetchedResults<Offense>
    
    @Binding var searchKey: String

    @State private var tab:tabType = .offense

    var body: some View {
        VStack{
            TabView(selection: $tab){
                FilteredOffenseListView(key: searchKey, filters: fvm.filters, favoritesOnly: true)
                    .tag(tabType.offense)

                FilteredCrimeListView(key: searchKey, filters: fvm.filters, favoritesOnly: true)
                    .tag(tabType.crime)
            }
            .tabViewStyle(.page)
            
        }
    }
}
