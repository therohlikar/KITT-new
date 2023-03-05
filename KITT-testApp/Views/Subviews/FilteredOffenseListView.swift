//
//  FilteredOffenseListView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/5/23.
//

import SwiftUI

struct FilteredOffenseListView: View{
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: nil) var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var foundResults: FetchedResults<Offense>
    
    private var searchKey:String = ""
    private var favorites: Bool = false
    
    var body: some View{
        if !searchKey.isEmpty || favorites{
            if foundResults.count > 0{
                ForEach(foundResults, id:\.self) { offense in
                    NavigationLink {
                        ContentSubView(contentItem: offense)
                    } label: {
                        VStack(alignment: .leading){
                            Text(offense.wrappedTitle)
                                .fontWeight(.light)
                            VStack{
                                Text(offense.paragraphModel.toString())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .isDetailLink(false)
                }
            }else{
                Text("Nothing was found")
            }
            
        }else{
            ForEach(groups, id: \.self) { group in
                Section(header:
                    HStack{
                        Text(group.wrappedTitle)
                    }
                    .font(.headline)
                ) {
                    ForEach(group.offenseArray, id:\.self) { offense in
                        NavigationLink {
                            ContentSubView(contentItem: offense)
                        } label: {
                            VStack(alignment: .leading){
                                Text(offense.wrappedTitle)
                                    .fontWeight(.light)
                                VStack{
                                    Text(offense.paragraphModel.toString())
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .isDetailLink(false)
                    }
                }
            }
        }
        
    }
    
    init(key: String = "", filters: [FilterModel], favoritesOnly: Bool = false){
        var filterPredicates: [NSPredicate] = []
        
        if !key.isEmpty {
            for filter in filters {
                if filter.active{
                    filterPredicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", filter.key, key))
                }
            }
        }else {
            filterPredicates.append(NSPredicate(value: true))
        }
        
        _foundResults = FetchRequest<Offense>(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: NSCompoundPredicate(type: .and, subpredicates: [NSCompoundPredicate(orPredicateWithSubpredicates: filterPredicates), NSPredicate(format: favoritesOnly ? "isFavorited == true" : "isFavorited == true OR isFavorited == false")]))
 
        searchKey = key
        favorites = favoritesOnly
    }
}
