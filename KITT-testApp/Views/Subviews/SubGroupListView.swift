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
    
    @State private var categoriesRoll: Bool = false
    
    var favoritesOnly: Bool
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                GroupBox(content: {
                    VStack(alignment: .leading){
                        HStack{
                            Text("KATEGORIE")
                                .padding(.bottom, categoriesRoll ? 3 : 0)
                            Spacer()
                            Image(systemName: categoriesRoll ? "arrow.up.circle" : "arrow.down.circle")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring()) {
                                categoriesRoll.toggle()
                            }
                        }
                        
                        if categoriesRoll {
                            ForEach(dict, id: \.description) { subgroup in
                                HStack{
                                    Button("- \(subgroup.description.uppercased())") {
                                        withAnimation(.spring()) {
                                            value.scrollTo(subgroup.description, anchor: .top)
                                        }
                                    }
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                    
                                    Spacer()
                                }
                                .padding(.bottom, 2)
                            }
                        }
                    }
                })
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
                let sorted = currentGroup.ciArray.sorted{
                    $0.wrappedTitle < $1.wrappedTitle
                }
                
                for item in sorted {
                    if !item.wrappedSubgroup.isEmpty && !dict.contains(where: {$0 == item.wrappedSubgroup}) {
                        dict.append(item.wrappedSubgroup)
                    }
                }
                
                dict.sort{
                    $0.description < $1.description
                }
            }
        }
        
    }
}
