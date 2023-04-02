//
//  SubGroupListView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/29/23.
//

import SwiftUI

struct SubGroupListView: View {
    @ObservedObject var currentGroup: Group
    @State private var dict = [String]()
    @State private var searchKey: String = ""
    
    var favoritesOnly: Bool
    
    var body: some View {
        List {
            ForEach(dict, id: \.description) { subgroup in
                Section {
                    ForEach(currentGroup.ciArray) { item in
                        if favoritesOnly == false || item.favorited == favoritesOnly {
                            NavigationLink {
                                ContentItemView(item: item)
                            } label: {
                                Text(item.wrappedTitle)
                            }
                            .isDetailLink(false)
                        }
                    }
                } header: {
                    Text(subgroup.description)
                }
            }
        }
        .searchable(text: $searchKey)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(currentGroup.wrappedTitle)
        .listStyle(.plain)
        .onAppear{
            for group in currentGroup.ciArray {
                if !group.wrappedSubgroup.isEmpty && !dict.contains(where: {$0 == group.wrappedSubgroup}) {
                    dict.append(group.wrappedSubgroup)
                }
            }
        }
    }
    
    
}
