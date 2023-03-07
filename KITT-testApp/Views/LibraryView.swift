//
//  NewVersionKittListView.swift
//  KITT
//
//  Created by Radek Jeník on 3/2/23.
//

import SwiftUI


enum tabType{
    case offense, crime, lawextract
}

struct LibraryView: View {
    @EnvironmentObject var fvm: FilterViewModel
    @EnvironmentObject var sc: SettingsController

    @Binding var searchKey: String

    @State private var tab:tabType = .offense
    
    var body: some View {
        VStack{
            TabView(selection: $tab){
                // OFFENSE
                List{
                    Section("Offenses"){
                        FilteredOffenseListView(key: searchKey, filters: fvm.offenseFilters)
                    }
                }
                .listStyle(.sidebar)
                .tag(tabType.offense)
                
                // CRIME
                List{
                    Section("Crimes"){
                        FilteredOffenseListView(key: searchKey, filters: fvm.offenseFilters)
                    }
                }
                .listStyle(.sidebar)
                .tag(tabType.crime)
            }
            .tabViewStyle(.page)
        }
        
    }
}




