//
//  MainView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var offenses: FetchedResults<Offense>
    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Group>
    
    var body: some View {
        NavigationView{
            TabView{
                LibraryView()
                    .tabItem {
                        Label("Knihovna", systemImage: "books.vertical.fill")
                    }
                    .tag("categories")
                
                FavoritesView()
                    .tabItem {
                        Label("Oblíbené", systemImage: "heart")
                    }
                    .tag("favorites")
                
                
            }
        }
        .task {
            let jsonController = JsonDataController()
            if let offenseArray = await jsonController.downloadJsonData(.offense) as? Array<OffenseModel> {
                for item in offenseArray {
                    var note: String = ""
                    var isFavorited: Bool = false
                    
                    if let existingOffense = offenses.first(where: {$0.id == item.paragraph}){
                        note = existingOffense.wrappedNote
                        isFavorited = existingOffense.isFavorited
                    }
                    
                    let newOffense = Offense(context: moc)
                    newOffense.id = item.paragraph
                    // id is same as paragraph, which is unique all the time
                    //loop through groups, if any, and create or invite them in
                    for group in item.groups{
                        let newGroup:Group = Group(context: moc)
                        newGroup.title = group
                        newOffense.addToGroup(newGroup)
                    }	
                    newOffense.title = item.title
                    newOffense.content = item.content
                    newOffense.paragraph = item.paragraph
                    newOffense.violationParagraph = item.violationParagraph
                    newOffense.resolveOptions = item.resolveOptions
                    newOffense.offenseScore = Int16(item.offenseScore)
                    newOffense.isOffenseTracked = item.isOffenseTracked
                    newOffense.fineExample = item.fineExample
                    
                    newOffense.note = note
                    newOffense.isFavorited = isFavorited
                }
            }
            
            //clear groups
            for group in groups {
                if group.offenseArray.isEmpty {
                    moc.delete(group)
                }
            }
            
            try? moc.save()
        }
    }
}
