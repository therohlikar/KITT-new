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
    @EnvironmentObject var networkController: NetworkController
    @EnvironmentObject var sc: SettingsController
    
    @FetchRequest(sortDescriptors: []) var offenses: FetchedResults<Offense>
    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var crimes: FetchedResults<Crime>
    @FetchRequest(sortDescriptors: []) var lawextracts: FetchedResults<LawExtract>
    @FetchRequest(sortDescriptors: []) var versions: FetchedResults<Version>
    
    @State private var ready: Bool = false
    @State private var searchKey: String = ""
    @State private var filterListViewOpened: Bool = false
    @State private var settingsViewOpened: Bool = false
    @State private var navigationButtonID = UUID()
    @State private var preferredPanel: String = UserDefaults.standard.string(forKey: "settings.preferredPanel") ?? "library"
    
    @FocusState private var searchFocused: Bool
    
    @AppStorage("settings.searchOnTop") private var searchOnTop: Bool = false
    @AppStorage("currentVersion") private var currentVersion: String = "0.0.0"
    @AppStorage("catchYourCriminalUnlocked") private var catchYourCriminalUnlocked: Bool = false
    @AppStorage("firstOpen") private var firstOpen: Bool = false
    
    @State private var isBored: Bool = false
    
    var body: some View {
        NavigationStack{
            if !ready{
                ProgressView("Aplikace se připravuje")
                    .tint(.blue)
            }else{
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
                    .contentShape(Rectangle())
                    
                    if !searchOnTop {
                        TextField("Vyhledávání...", text: $searchKey)
                            .autocorrectionDisabled()
                            .padding(10)
                            .focused($searchFocused)
                            .onSubmit {
                                if searchKey.lowercased() == "i am bored" || searchKey.lowercased() == "nudím se" || searchKey.lowercased() == "nuda" {
                                    catchYourCriminalUnlocked = true
                                    isBored.toggle()
                                }
                            }
                    }
                }
                .navigationDestination(isPresented: $isBored, destination: {
                    CYCMenuView()
                })
                .toolbar{
                    if searchOnTop {
                        ToolbarItem(placement: .navigation) {
                            TextField("Vyhledávání...", text: $searchKey)
                                .autocorrectionDisabled()
                                .padding(10)
                                .focused($searchFocused)
                                .onSubmit {
                                    if searchKey.lowercased() == "i am bored" || searchKey.lowercased() == "nudím se" || searchKey.lowercased() == "nuda" {
                                        catchYourCriminalUnlocked = true
                                        isBored.toggle()
                                    }
                                }
                        }
                    }
                    
                    if catchYourCriminalUnlocked {
                        ToolbarItem(placement: .navigationBarLeading) {
                            NavigationLink {
                                CYCMenuView()
                            } label: {
                                Image("criminal")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                            .isDetailLink(false)
                        }
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
                    if !networkController.connected {
                        ToolbarItem(placement: .status) {
                            HStack{
                                Text("Nejste připojen k Internetu")
                                    .frame(width: 400, height: 25, alignment: .center)
                                    .padding(2)
                                    .background(Color("NetworkErrorColor"))
                                    .cornerRadius(25)
                            }
                        }
                    }
                }
                .navigationBarTitle("")
                .sheet(isPresented: $filterListViewOpened) {
                    FiltersList(fvm: fvm)
                        .preferredColorScheme(sc.settings.darkMode ? .dark : .light)
                }
                .sheet(isPresented: $settingsViewOpened) {
                    SettingsView()
                        .preferredColorScheme(sc.settings.darkMode ? .dark : .light)
                }
            }
        }
        .task {
            if !networkController.connected {
                ready = true
            }else{
                let newestVersion = await VersionController().getNewestVersion()
                print(newestVersion, currentVersion)
                if newestVersion <= currentVersion {
                    ready = true
                }
                else {
                    if let versionArray = await VersionController().loadVersionUpdates() {
                        var read:Bool = false
                        for item in versionArray {
                            read = false
                            if let versionExists = versions.first(where: {$0.version == item.version }){
                                read = versionExists.read
                            }
                            
                            let version = Version(context: moc)
                            version.version = item.version
                            version.content = item.news.joined(separator: "\n")
                            version.read = read
                        }
                    }
                    
                    let jsonController = JsonDataController()
                    if let offenseArray: Array<OffenseModel> = await jsonController.downloadJsonData(.offense) as? Array<OffenseModel> {
                        var note: String = ""
                        var isFavorited: Bool = false
                        var customId: String? = ""
                        
                        for item in offenseArray {
                            note = item.note
                            isFavorited = false
                            customId = item.id == nil ? item.paragraph : item.id
                            
                            if let existingOffense = offenses.first(where: {$0.id == customId}){
                                note = existingOffense.wrappedNote
                                isFavorited = existingOffense.isFavorited
                                
                                existingOffense.group = nil
                                
                                moc.delete(existingOffense)
                            }
                            
                            let newOffense = Offense(context: moc)
                            newOffense.id = customId
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
                            newOffense.miranda = item.miranda
                            newOffense.warning = item.warning
                            
                            newOffense.note = note
                            newOffense.isFavorited = isFavorited
                        }
                        
                        // list through all offenses and if it is NOT on the remote by its id, remove test
                        for duplicate in offenses {
                            if !offenseArray.contains(where: { $0.id != nil ? $0.id == duplicate.id : $0.paragraph == duplicate.paragraph }) {
                                moc.delete(duplicate)
                            }
                        }
                    }
                    if let crimeArray = await jsonController.downloadJsonData(.crime) as? Array<CrimeModel> {
                        var note: String = ""
                        var isFavorited: Bool = false
                        for item in crimeArray {
                            note = item.note
                            isFavorited = false
                            
                            if let existingCrime = crimes.first(where: {$0.id == item.paragraph}){
                                note = existingCrime.wrappedNote
                                isFavorited = existingCrime.isFavorited
                                
                                existingCrime.group = nil
                                
                                moc.delete(existingCrime)
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
                            newCrime.miranda = item.miranda
                            newCrime.warning = item.warning
                            
                            newCrime.note = note
                            newCrime.isFavorited = isFavorited
                        }
                        
                        for duplicate in crimes {
                            if !crimeArray.contains(where: { $0.id != nil ? $0.id == duplicate.id : $0.paragraph == duplicate.paragraph }) {
                                moc.delete(duplicate)
                            }
                        }
                    }
                    if let leArray = await jsonController.downloadJsonData(.lawextract) as? Array<LawExtractModel> {
                        var note: String = ""
                        var isFavorited: Bool = false
                        for item in leArray {
                            note = item.note
                            isFavorited = false
                            
                            if let existingLe = lawextracts.first(where: {$0.id == item.paragraph}){
                                note = existingLe.wrappedNote
                                isFavorited = existingLe.isFavorited
                                
                                existingLe.group = nil
                                
                                moc.delete(existingLe)
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
                            newLe.miranda = item.miranda
                            newLe.warning = item.warning
                            
                            newLe.note = note
                            newLe.isFavorited = isFavorited
                        }
                        
                        for duplicate in lawextracts {
                            if !leArray.contains(where: { $0.id != nil ? $0.id == duplicate.id : $0.paragraph == duplicate.paragraph }) {
                                moc.delete(duplicate)
                            }
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
                    
                    ready = true
                    if !firstOpen {
                        firstOpen = true
                    }
                }
            }
        }
    }
}
