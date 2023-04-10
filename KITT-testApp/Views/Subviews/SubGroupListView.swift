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
        ScrollView {
            ForEach(dict, id: \.description) { subgroup in
                LazyVStack {
                    HStack{
                        Text(subgroup.description.uppercased())
                            .font(.caption)
                        Spacer()
                    }
                    
                    ForEach(currentGroup.ciArray) { item in
                        if item.wrappedSubgroup == subgroup.description {
                            if favoritesOnly == false || item.favorited == favoritesOnly {
                                NavigationLink {
                                    ContentItemView(item: item)
                                } label: {
                                    ContentItemRowView(item: item)
                                }
                                .isDetailLink(false)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(currentGroup.wrappedTitle)
        .onAppear{
            for item in currentGroup.ciArray {
                if !item.wrappedSubgroup.isEmpty && !dict.contains(where: {$0 == item.wrappedSubgroup}) {
                    dict.append(item.wrappedSubgroup)
                }
            }
        }
    }
    
    
}
