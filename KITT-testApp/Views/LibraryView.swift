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
    
    @State private var searchKey: String = ""
    @State private var filterListViewOpened: Bool = false
    @State private var tab:tabType = .offense
    
    var body: some View {
        VStack{
            HStack{
                TextField("Search...", text: $searchKey)
                    .autocorrectionDisabled()
                    .padding(10)

                Image(systemName: "checklist")
                    .onTapGesture {
                        filterListViewOpened.toggle()
                    }
                    .padding(.horizontal, 10)
                    .foregroundColor(.blue)
            }
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
        .sheet(isPresented: $filterListViewOpened) {
            FiltersList(fvm: fvm)
        }
    }
}




