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
            Section("Filter Offenses Attributes"){
                ForEach(fvm.offenseFilters, id:\.label) { filter in
                    Button{
                        fvm.objectWillChange.send()
                        filter.active.toggle()
                    } label: {
                        Text(filter.label)
                    }
                    .foregroundColor(filter.active ? Color.white : Color.black)
                    .listRowBackground(filter.active ? Color.blue : Color.secondary)
                    .animation(.easeIn(duration: 0.8), value: filter.active)
                }
            }
        }
    }
}
