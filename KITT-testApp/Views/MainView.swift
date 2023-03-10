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
    @EnvironmentObject var fvm: FilterViewModel
    @FetchRequest(sortDescriptors: []) var offenses: FetchedResults<Offense>
    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var crimes: FetchedResults<Crime>
    @FetchRequest(sortDescriptors: []) var lawextracts: FetchedResults<LawExtract>
    
    @State private var searchKey: String = ""
    @State private var filterListViewOpened: Bool = false
    @State private var settingsViewOpened: Bool = false
    @State private var navigationButtonID = UUID()
    @State private var preferredPanel: String = UserDefaults.standard.string(forKey: "preferredPanel") ?? "library"
    
    @AppStorage("currentVersion") private var currentVersion: String = "0.0.0"
    
    var body: some View {
        NavigationStack{
            VStack{
                TabView(selection: $preferredPanel){
                    LibraryView(searchKey: $searchKey)
                        .tabItem {
                            Label("Knihovna", systemImage: "books.vertical.fill")
                        }
                        .tag("library")
                    
                    FavoritesView(searchKey: $searchKey)
                        .tabItem {
                            Label("Oblíbené", systemImage: "heart")
                                
                        }
                        .tag("favorites")
                }
            }
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    TextField("Vyhledávání...", text: $searchKey)
                        .autocorrectionDisabled()
                        .padding(10)
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "checklist")
                        .onTapGesture {
                           filterListViewOpened.toggle()
                        }
                        .padding(.horizontal, 10)
                        .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "gearshape.fill")
                        .onTapGesture {
                           settingsViewOpened.toggle()
                        }
                        .padding(.horizontal, 10)
                        .padding(.trailing, 2)
                        .foregroundColor(.secondary)
                }
            }
            .navigationBarTitle("")
            .sheet(isPresented: $filterListViewOpened) {
                FiltersList(fvm: fvm)
            }
            .sheet(isPresented: $settingsViewOpened) {
                SettingsView()
            }
            .task {
                let newestVersion = await VersionController().getNewestVersion()
                
                if newestVersion > currentVersion {
                    if let versionArray = await VersionController().loadVersionUpdates() {
                        for item in versionArray {
                            let version = Version(context: moc)
                            version.version = item.version
                            version.content = item.news.joined(separator: "\n")
                        }
                    }
                    
                    let jsonController = JsonDataController()
                    if let offenseArray = await jsonController.downloadJsonData(.offense) as? Array<OffenseModel> {
                        for item in offenseArray {
                            var note: String = ""
                            var isFavorited: Bool = false
                            
                            if let existingOffense = offenses.first(where: {$0.id == item.paragraph}){
                                note = existingOffense.wrappedNote
                                isFavorited = existingOffense.isFavorited
                                
                                existingOffense.group = nil
                            }
                            
                            let newOffense = Offense(context: moc)
                            newOffense.id = item.paragraph
                            // id is same as paragraph, which is unique all the time
                            //loop through groups, if any, and create or invite them in
                            for group in item.groups{
                                let newGroup:Group = Group(context: moc)
                                newGroup.title = group
                                newOffense.addToGroup(newGroup)
                                
                                print(group)
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
                    if let crimeArray = await jsonController.downloadJsonData(.crime) as? Array<CrimeModel> {
                        for item in crimeArray {
                            var note: String = ""
                            var isFavorited: Bool = false
                            
                            if let existingCrime = crimes.first(where: {$0.id == item.paragraph}){
                                note = existingCrime.wrappedNote
                                isFavorited = existingCrime.isFavorited
                                
                                existingCrime.group = nil
                            }
                            
                            let newCrime = Crime(context: moc)
                            newCrime.id = item.paragraph
                            // id is same as paragraph, which is unique all the time
                            //loop through groups, if any, and create or invite them in
                            for group in item.groups{
                                let newGroup:Group = Group(context: moc)
                                newGroup.title = group
                                newCrime.addToGroup(newGroup)
                            }
                            newCrime.title = item.title
                            newCrime.content = item.content
                            newCrime.paragraph = item.paragraph
                            newCrime.crimeExample = item.crimeExample
                            
                            newCrime.note = note
                            newCrime.isFavorited = isFavorited
                        }
                    }
                    if let leArray = await jsonController.downloadJsonData(.lawextract) as? Array<LawExtractModel> {
                        for item in leArray {
                            var note: String = ""
                            var isFavorited: Bool = false

                            if let existingLe = lawextracts.first(where: {$0.id == item.paragraph}){
                                note = existingLe.wrappedNote
                                isFavorited = existingLe.isFavorited
                                
                                existingLe.group = nil
                            }

                            let newLe = LawExtract(context: moc)
                            newLe.id = item.paragraph
                            // id is same as paragraph, which is unique all the time
                            //loop through groups, if any, and create or invite them in
                            for group in item.groups{
                                let newGroup:Group = Group(context: moc)
                                newGroup.title = group
                                newLe.addToGroup(newGroup)
                            }
                            newLe.title = item.title
                            newLe.content = item.content
                            newLe.paragraph = item.paragraph

                            newLe.note = note
                            newLe.isFavorited = isFavorited
                        }
                    }
                    
                    //clear groups
                    for group in groups {
                        if group.offenseArray.isEmpty && group.crimeArray.isEmpty && group.leArray.isEmpty {
                            moc.delete(group)
                        }
                    }
                    
                    try? moc.save()
                    
                    currentVersion = newestVersion
                }
            }
        }
    }
}
