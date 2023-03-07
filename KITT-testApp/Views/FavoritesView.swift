//
//  FavoritesView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var fvm: FilterViewModel
    @EnvironmentObject var sc: SettingsController
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isFavorited == true")) var favorites: FetchedResults<Offense>
    
    @Binding var searchKey: String

    @State private var tab:tabType = .offense

    var body: some View {
        VStack{
            TabView(selection: $tab){
                // OFFENSE
                List{
                    Section("Offenses"){
                        FilteredOffenseListView(key: searchKey, filters: fvm.offenseFilters, favoritesOnly: true)
                    }
                }
                .listStyle(.sidebar)
                .tag(tabType.offense)
                
                // CRIME
                List{
                    Section("Crimes"){
                        FilteredOffenseListView(key: searchKey, filters: fvm.offenseFilters, favoritesOnly: true)
                    }
                }
                .listStyle(.sidebar)
                .tag(tabType.crime)
            }
            .tabViewStyle(.page)
            
        }
    }
}
