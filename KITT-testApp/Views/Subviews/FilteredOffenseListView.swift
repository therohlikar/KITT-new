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
        List{
            Section{
                if !searchKey.isEmpty || favorites{
                    if foundResults.count > 0{
                        ForEach(foundResults, id:\.self) { offense in
                            NavigationLink {
                                ContentSubView(contentItem: offense)
                            } label: {
                                OffenseRowListView(offense: offense)
                            }
                            .isDetailLink(false)
                        }
                    }else{
                        Text("Nic nebylo nalezeno")
                    }
                }else{
                    ForEach(groups, id: \.self) { group in
                        if !group.offenseArray.isEmpty{
                            DisclosureGroup {
                                ForEach(group.offenseArray, id:\.self) { offense in
                                    NavigationLink {
                                        ContentSubView(contentItem: offense)
                                    } label: {
                                        OffenseRowListView(offense: offense)
                                    }
                                    .isDetailLink(false)
                                }
                            } label: {
                                HStack{
                                    Text(group.wrappedTitle)
                                }
                                .font(.headline)
                            }
                        }
                    }
                }
            } header: {
                Text("Přestupky")
                    .fontWeight(.light)
            }
            .headerProminence(.increased)
        }
        .listStyle(.sidebar)
    }
    
    init(key: String = "", filters: [FilterModel], favoritesOnly: Bool = false){
        var filterPredicates: [NSPredicate] = []
        
        if !key.isEmpty {
            for filter in filters {
                if filter.active && (filter.specific == "" || filter.specific == nil || filter.specific == "offense"){
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

struct OffenseRowListView: View{
    @EnvironmentObject var sc: SettingsController
    @ObservedObject var offense: Offense
    @State private var isDetailShown: Bool = false
    
    var body: some View{
        VStack(alignment: .leading){
            Text(offense.wrappedTitle)
                .fontWeight(.light)
                .onTapGesture {
                    if !sc.settings.showDetail {
                        isDetailShown.toggle()
                    }
                    
                }
            VStack(alignment: .leading){
                Text(offense.paragraphModel.toString())
                if !offense.wrappedViolationParagraph.isEmpty {
                    Text("PŘ: \(offense.violationParagraphModel.toString())")
                }
                if isDetailShown || sc.settings.showDetail {
                    HStack(alignment: .top){
                        if !offense.wrappedResolveOptions.isEmpty{
                            VStack{
                                Text("Řešení")
                                    .bold()
                                Text(offense.wrappedResolveOptions)
                            }
                        }
                        if offense.offenseScore >= 0 {
                            VStack{
                                Text("Body")
                                    .bold()
                                Text("\(offense.offenseScore)")
                            }
                        }
                        VStack{
                            Text("Sledovaný přestupek")
                                .bold()
                            Text(offense.isOffenseTracked ? "Ano" : "Ne")
                        }
                    }
                    .padding(1)
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
}


struct FilteredCrimeListView: View{
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: nil) var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var foundResults: FetchedResults<Crime>
    
    private var searchKey:String = ""
    private var favorites: Bool = false
    
    var body: some View{
        List{
            Section{
                if !searchKey.isEmpty || favorites{
                    if foundResults.count > 0{
                        ForEach(foundResults, id:\.self) { crime in
                            NavigationLink {
                                ContentSubView(contentItem: crime)
                            } label: {
                                CrimeRowListView(crime: crime)
                            }
                            .isDetailLink(false)
                        }
                    }else{
                        Text("Nic nebylo nalezeno")
                    }
                }else{
                    ForEach(groups, id: \.self) { group in
                        if !group.crimeArray.isEmpty{
                            DisclosureGroup {
                                ForEach(group.crimeArray, id:\.self) { crime in
                                    NavigationLink {
                                        ContentSubView(contentItem: crime)
                                    } label: {
                                        CrimeRowListView(crime: crime)
                                    }
                                    .isDetailLink(false)
                                }
                            } label: {
                                HStack{
                                    Text(group.wrappedTitle)
                                }
                                .font(.headline)
                            }
                        }
                    }
                }
            } header: {
                Text("Trestné činy")
                    .fontWeight(.light)
            }
            .headerProminence(.increased)
        }
        .listStyle(.sidebar)
    }
    
    init(key: String = "", filters: [FilterModel], favoritesOnly: Bool = false){
        var filterPredicates: [NSPredicate] = []
        
        if !key.isEmpty {
            for filter in filters {
                if filter.active && (filter.specific == "" || filter.specific == nil || filter.specific == "crime"){
                    filterPredicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", filter.key, key))
                }
            }
        }else {
            filterPredicates.append(NSPredicate(value: true))
        }
        
        _foundResults = FetchRequest<Crime>(sortDescriptors: [NSSortDescriptor(key: "title", ascending: true)], predicate: NSCompoundPredicate(type: .and, subpredicates: [NSCompoundPredicate(orPredicateWithSubpredicates: filterPredicates), NSPredicate(format: favoritesOnly ? "isFavorited == true" : "isFavorited == true OR isFavorited == false")]))
 
        searchKey = key
        favorites = favoritesOnly
    }
}

struct CrimeRowListView: View{
    @EnvironmentObject var sc: SettingsController
    @ObservedObject var crime: Crime
    
    var body: some View{
        VStack(alignment: .leading){
            Text(crime.wrappedTitle)
                .fontWeight(.light)
            VStack(alignment: .leading){
                Text(crime.paragraphModel.toString())
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
}
