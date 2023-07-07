//
//  NewVersionKittListView.swift
//  KITT
//
//  Created by Radek Jeník on 3/2/23.
//

import SwiftUI

struct LibraryView: View {
    @FetchRequest(sortDescriptors: []) var offenseGroups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var crimeGroups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var lawGroups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var signGroup: FetchedResults<Group>
    
    @FetchRequest(sortDescriptors: []) var searchedContent: FetchedResults<ContentItem>
    
    var favoritesOnly: Bool
    var searchKey: String
    
    var body: some View {
        ScrollView{
            if searchKey.isEmpty && !favoritesOnly {
                LazyVStack {
                    HStack{
                        Text("PŘESTUPKY".uppercased())
                            .font(.caption)
                        Spacer()
                    }
                    ForEach(offenseGroups) { group in
                        NavigationLink {
                            SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                        } label: {
                            HStack{
                                Spacer()
                                Text(group.wrappedTitle)
                                    .padding()
                                    .font(.subheadline)
                                    .fontWeight(.medium)

                                Spacer()
                            }
                            .foregroundColor(.primary)
                            .frame(minWidth: 310, minHeight: 80)
                            .background(
                                Color(#colorLiteral(red: 0, green: 0.431452632, blue: 0.77961272, alpha: 0.5))
                            )
                            .cornerRadius(7)
                        }
                        .isDetailLink(false)
                    }
                }
                LazyVStack {
                    HStack{
                        Text("TRESTNÉ ČINY".uppercased())
                            .font(.caption)
                        Spacer()
                    }
                    ForEach(crimeGroups) { group in
                        NavigationLink {
                            SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                        } label: {
                            HStack{
                                Spacer()
                                Text(group.wrappedTitle)
                                    .padding()
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                            .foregroundColor(.primary)
                            .frame(minWidth: 310, minHeight: 80)
                            .background(
                                Color(#colorLiteral(red: 0.7391448617, green: 0, blue: 0.02082144469, alpha: 0.5))
                            )
                            .cornerRadius(7)
                        }
                        .isDetailLink(false)
                    }
                }
                LazyVStack {
                    HStack{
                        Text("CITACE ZÁKONA".uppercased())
                            .font(.caption)
                        Spacer()
                    }
                    ForEach(lawGroups) { group in
                        NavigationLink {
                            SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                        } label: {
                            HStack{
                                Spacer()
                                Text(group.wrappedTitle)
                                    .padding()
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                            .foregroundColor(.primary)
                            .frame(minWidth: 310, minHeight: 80)
                            .background(
                                Color(#colorLiteral(red: 0.9611360431, green: 0.5784681439, blue: 0, alpha: 0.5))
                            )
                            .cornerRadius(7)
                        }
                        .isDetailLink(false)
                    }
                }
                LazyVStack {
                    HStack{
                        Text("OSTATNÍ".uppercased())
                            .font(.caption)
                        Spacer()
                    }
                    ForEach(signGroup) { group in
                        NavigationLink {
                            SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                        } label: {
                            HStack{
                                Spacer()
                                Text(group.wrappedTitle)
                                    .padding()
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                            }
                            .foregroundColor(.primary)
                            .frame(minWidth: 310, minHeight: 80)
                            .background(
                                Color(#colorLiteral(red: 0.7754455209, green: 0.7807555795, blue: 0.7612403035, alpha: 0.5))
                            )
                            .cornerRadius(7)
                        }
                        .isDetailLink(false)
                    }
                }
            }else{
                LazyVStack {
                    HStack{
                        Text(favoritesOnly ? "Oblíbené:".uppercased() : "Nalezené:".uppercased())
                            .font(.caption)
                        Spacer()
                    }
                    
                    ForEach(searchedContent) { item in
                        NavigationLink {
                            ContentItemView(item: item)
                        } label: {
                            ContentItemRowView(item: item)
                        }
                        .isDetailLink(false)
                        .onTapGesture {
                            
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .onAppear{
            UIApplication.shared.endEditing()
        }
    }
    
    init(searchKey: String = "", favoritesOnly: Bool = false, fvm: FilterViewModel){
        var filterPredicates: [NSPredicate] = []
        self.searchKey = searchKey
        self.favoritesOnly = favoritesOnly
        
        if !searchKey.isEmpty || favoritesOnly {
            if !searchKey.isEmpty {
                for filter in fvm.filters {
                    if filter.active{
                        filterPredicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", filter.key, searchKey))
                    }
                }
            }else{
                filterPredicates.append(NSPredicate(value: true))
            }

            _searchedContent = FetchRequest<ContentItem>(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: NSCompoundPredicate(
                type: .and, subpredicates: [NSCompoundPredicate(orPredicateWithSubpredicates: filterPredicates), NSPredicate(format: favoritesOnly ? "favorited == true" : "favorited == true OR favorited == false")]))
        }else {
            _offenseGroups = FetchRequest<Group>(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: NSCompoundPredicate(
                type: .and, subpredicates: [NSPredicate(format: "ANY contentitem.type == 'offense'")]))

            _crimeGroups = FetchRequest<Group>(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: NSCompoundPredicate(
                type: .and, subpredicates: [NSPredicate(format: "ANY contentitem.type == 'crime'")]))
            
            _lawGroups = FetchRequest<Group>(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: NSCompoundPredicate(
                type: .and, subpredicates: [NSPredicate(format: "ANY contentitem.type == 'law'")]))
            
            _signGroup = FetchRequest<Group>(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: NSCompoundPredicate(
                type: .and, subpredicates: [NSPredicate(format: "ANY contentitem.type == 'sign'")]))
        }
    }
}




