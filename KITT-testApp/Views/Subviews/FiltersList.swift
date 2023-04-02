//
//  FiltersList.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/5/23.
//

import SwiftUI

struct FiltersList: View{
    @ObservedObject var fvm: FilterViewModel
    @EnvironmentObject var sc: SettingsController
    
    @Binding var onlyFavorites: Bool

    var body: some View{
        List{
            HStack{
                Text("Pouze oblíbené")
                Spacer()
                Toggle("", isOn: $onlyFavorites)
                    .labelsHidden()
                    .tint(.red)
            }
            .font(.caption)
            
            Section("Filtry vyhledávání") {
                ForEach($fvm.filters, id:\.label) { $filter in
                    HStack{
                        Text(filter.label)
                        Spacer()
                        Toggle("", isOn: $filter.active)
                            .labelsHidden()
                    }
                    .font(.caption)
                }
            }
        }
        .tint(.blue)
        .onDisappear{
            if sc.settings.saveFilters{
                fvm.encodeLocalFilters()
            }
        }
    }
}
