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
    @EnvironmentObject var dc: DataController

    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<ContentItem>
    @FetchRequest(sortDescriptors: []) var versions: FetchedResults<Version>

    @State private var ready: Bool = false
    @State private var searchKey: String = ""
    @State private var filterListViewOpened: Bool = false
    @State private var settingsViewOpened: Bool = false
    @State private var submenuViewOpened: Bool = false
    @State private var onlyFavorites: Bool = false
    
    @FocusState private var searchFocused: Bool
    
    @AppStorage("settings.searchOnTop") private var searchOnTop: Bool = false
    @AppStorage("currentVersion") private var currentVersion: String = "0.0.0"

    @State private var toBeUpdated: Bool = false
    @State private var settingsToOpen: Bool = false

    var body: some View {
        NavigationStack{
            if !ready{
                ProgressView("Aplikace se připravuje")
                    .tint(.blue)
            }else{
                VStack{
                    LibraryView(searchKey: searchKey, favoritesOnly: onlyFavorites, fvm: fvm)
                        .tabItem {
                            Label("Knihovna", systemImage: "books.vertical.fill")
                        }
                        .tag("library")
                    
                    Spacer()
                    
                    if !searchOnTop {
                        TextField("Vyhledávání...", text: $searchKey)
                            .autocorrectionDisabled()
                            .padding(10)
                            .focused($searchFocused)
                    }
                }
                .refreshable {
                    currentVersion = "0.0.0"
                    Task {
                        await self.prepareData()
                    }
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .toolbar{
                    if searchOnTop {
                        ToolbarItem(placement: .navigation) {
                            TextField("Vyhledávání...", text: $searchKey)
                                .autocorrectionDisabled()
                                .padding(10)
                                .focused($searchFocused)
                        }
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: onlyFavorites ? "heart.fill" : "heart")
                            .onTapGesture {
                                onlyFavorites.toggle()
                            }
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.6247290969, green: 0, blue: 0, alpha: 1)))
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "checklist")
                            .onTapGesture {
                                searchFocused = false
                                
                                filterListViewOpened.toggle()
                            }
                            .padding(.horizontal, 10)
                            .foregroundColor(.blue)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "line.3.horizontal.circle")
                            .onTapGesture {
                                searchFocused = false
                                
                                submenuViewOpened.toggle()
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
                .sheet(isPresented: $settingsViewOpened, onDismiss: {
                    //
                }, content: {
                    SettingsView(update: $toBeUpdated, isPresented: $settingsViewOpened)
                        .preferredColorScheme(sc.settings.darkMode ? .dark : .light)
                        .onDisappear{
                            if toBeUpdated {
                                toBeUpdated = false
                                Task {
                                    await self.prepareData()
                                }
                            }
                        }
                })
                .sheet(isPresented: $filterListViewOpened, onDismiss: {
                    searchFocused = true
                }, content: {
                    FiltersList(fvm: fvm, onlyFavorites: $onlyFavorites)
                        .preferredColorScheme(sc.settings.darkMode ? .dark : .light)
                })
                .sheet(isPresented: $submenuViewOpened) {
                    //
                } content: {
                    SubmenuView(settingsToOpen: $settingsToOpen, submenuViewOpened: $submenuViewOpened)
                        .onDisappear{
                            settingsViewOpened = settingsToOpen
                            
                            settingsToOpen = false
                        }
                }

            }
        }
        .task {
            await self.prepareData()
        }
    }
    
    func prepareData() async {
        ready = false
        
        if !networkController.connected {
            ready = true
        }else{
            let newestVersion = await VersionController().getNewestVersion()
            
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

                if let ciArray = await jsonController.downloadJsonData(.contentitem) as? Array<ItemModel> {
                    for item in ciArray {
                        //prepare group
                        let group = Group(context: moc)
                        group.title = item.group

                        let new = ContentItem(context: moc)
                        new.id = item.id
                        
                        var currentFavorited = false
                        var currentNote = ""
                        
                        if let exists = items.first(where: {$0.id == item.id}){
                            currentFavorited = exists.favorited
                            currentNote = exists.wrappedNote
                        }
                        
                        new.group = group
                        var subgroupName = item.subgroup ?? "NEZAŘAZENO"
                        if subgroupName.isEmpty {
                            subgroupName = "NEZAŘAZENO"
                        }
                        new.subgroup = subgroupName
                        new.type = item.type
                        new.title = item.title
                        new.sanctions = item.sanctions
                        new.links = item.links
                        new.keywords = item.keywords
                        new.warning = item.warning
                        new.miranda = item.miranda
                        new.content = item.content
                        new.example = item.example
                        
                        new.note = currentNote
                        new.favorited = currentFavorited
                    }
                    
                    for item in items {
                        if !ciArray.contains(where: {$0.id == item.wrappedId}){
                            moc.delete(item)
                        }
                    }
                }
                
                dc.trySave()
                
                currentVersion = newestVersion
                
                ready = true
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
