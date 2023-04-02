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
    
    @FetchRequest(sortDescriptors: []) var searchedContent: FetchedResults<ContentItem>
    
    var favoritesOnly: Bool
    var searchKey: String
    
    var body: some View {
        VStack{
            List{
                if searchKey.isEmpty && !favoritesOnly {
                    Section {
                        ForEach(offenseGroups) { group in
                            NavigationLink {
                                SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                            } label: {
                                Text(group.wrappedTitle)
                            }
                            .isDetailLink(false)
                        }
                    } header: {
                        Text("PŘESTUPKY")
                    }

                    Section {
                        ForEach(crimeGroups) { group in
                            NavigationLink {
                                SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                            } label: {
                                Text(group.wrappedTitle)
                            }
                            .isDetailLink(false)
                        }
                    } header: {
                        Text("TRESTNÉ ČINY")
                    }
                }else{
                    Section {
                        ForEach(searchedContent) { item in
                            NavigationLink {
                                ContentItemView(item: item)
                            } label: {
                                VStack(alignment: .leading){
                                    Text(item.wrappedType)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(item.wrappedTitle)
                                }
                            }
                            .isDetailLink(false)
                        }
                    } header: {
                        Text(favoritesOnly ? "Oblíbené:" : "Nalezené:")
                    }

                }
            }
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
        }
    }
}




