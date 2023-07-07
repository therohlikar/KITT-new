//
//  FiltersList.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/5/23.
//

import SwiftUI

struct FiltersList: View{
    @ObservedObject var fvm: FilterViewModel
    
    var body: some View{
        List{
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
            fvm.encodeLocalFilters()
        }
    }
}
