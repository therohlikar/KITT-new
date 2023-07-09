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
                        Text("PŘESTUPKY")
                            .font(Font.caption2)
                        
                        Spacer()
                    }
                    .padding(.bottom, 2)
                    .foregroundColor(.primary)
                    
                    ForEach(offenseGroups) { group in
                        NavigationLink {
                            SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                        } label: {
                            HStack{
                                Rectangle()
                                    .frame(width: 10)
                                    .ignoresSafeArea(edges: [.leading, .top, .bottom])
                                    .foregroundColor(group.typeToColor)
                                    .roundedCorner(4, corners: .bottomLeft)
                                    .roundedCorner(4, corners: .topLeft)
                                
                                Spacer()
                                
                                VStack{
                                    
                                    
                                    Text(group.wrappedTitle)
                                        .fontWeight(Font.Weight.medium)
                                }
                                .padding()
                                
                                .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .frame(height: 75)
                            .background(
                                Color("ItemRowMenuColor")
                            )
                        }
                        .isDetailLink(false)
                    }
                }
                LazyVStack {
                    HStack{
                        Text("TRESTNÉ ČINY")
                            .font(Font.caption2)
                        
                        Spacer()
                    }
                    .padding(.bottom, 2)
                    .foregroundColor(.primary)
                    
                    ForEach(crimeGroups) { group in
                        NavigationLink {
                            SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                        } label: {
                            HStack{
                                Rectangle()
                                    .frame(width: 10)
                                    .ignoresSafeArea(edges: [.leading, .top, .bottom])
                                    .foregroundColor(group.typeToColor)
                                    .roundedCorner(4, corners: .bottomLeft)
                                    .roundedCorner(4, corners: .topLeft)
                                
                                Spacer()
                                
                                VStack{
                                    
                                    
                                    Text(group.wrappedTitle)
                                        .fontWeight(Font.Weight.medium)
                                }
                                .padding()
                                
                                .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .frame(height: 75)
                            .background(
                                Color("ItemRowMenuColor")
                            )
                        }
                        .isDetailLink(false)
                    }
                }
                LazyVStack {
                    HStack{
                        Text("VÝŇATKY ZE ZÁKONA")
                            .font(Font.caption2)
                        
                        Spacer()
                    }
                    .padding(.bottom, 2)
                    .foregroundColor(.primary)
                    
                    ForEach(lawGroups) { group in
                        NavigationLink {
                            SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                        } label: {
                            HStack{
                                Rectangle()
                                    .frame(width: 10)
                                    .ignoresSafeArea(edges: [.leading, .top, .bottom])
                                    .foregroundColor(group.typeToColor)
                                    .roundedCorner(4, corners: .bottomLeft)
                                    .roundedCorner(4, corners: .topLeft)
                                
                                Spacer()
                                
                                VStack{
                                    
                                    
                                    Text(group.wrappedTitle)
                                        .fontWeight(Font.Weight.medium)
                                }
                                .padding()
                                
                                .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .frame(height: 75)
                            .background(
                                Color("ItemRowMenuColor")
                            )
                        }
                        .isDetailLink(false)
                    }
                }
                LazyVStack {
                    HStack{
                        Text("DOPRAVNÍ ZNAČENÍ")
                            .font(Font.caption2)
                        
                        Spacer()
                    }
                    .padding(.bottom, 2)
                    .foregroundColor(.primary)
                    
                    ForEach(signGroup) { group in
                        NavigationLink {
                            SubGroupListView(currentGroup: group, favoritesOnly: favoritesOnly)
                        } label: {
                            HStack{
                                Rectangle()
                                    .frame(width: 10)
                                    .ignoresSafeArea(edges: [.leading, .top, .bottom])
                                    .foregroundColor(group.typeToColor)
                                    .roundedCorner(4, corners: .bottomLeft)
                                    .roundedCorner(4, corners: .topLeft)
                                
                                Spacer()
                                
                                VStack{
                                    
                                    
                                    Text(group.wrappedTitle)
                                        .fontWeight(Font.Weight.medium)
                                }
                                .padding()
                                
                                .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .frame(height: 75)
                            .background(
                                Color("ItemRowMenuColor")
                            )
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

            _searchedContent = FetchRequest<ContentItem>(sortDescriptors: [NSSortDescriptor(key: "type", ascending: true)], predicate: NSCompoundPredicate(
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

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
                            
extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}




