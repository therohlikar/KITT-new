//
//  MainView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import SwiftUI
import CoreData

struct MainView: View {
    @EnvironmentObject var fvm: FilterViewModel
    @EnvironmentObject var networkController: NetworkController
    @EnvironmentObject var sc: SettingsController
    @EnvironmentObject var dc: DataController
    
    @ObservedObject var urlViewModel: UrlViewModel = UrlViewModel()
    
    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<ContentItem>
    @FetchRequest(sortDescriptors: []) var versions: FetchedResults<Version>
    
    @State private var ready: Bool = true
    @State private var searchKey: String = ""
    @State private var filterListViewOpened: Bool = false
    @State private var settingsViewOpened: Bool = false
    @State private var submenuViewOpened: Bool = false
    @State private var onlyFavorites: Bool = false
    
    @FocusState private var searchFocused: Bool
    
    @AppStorage("settings.searchOnTop") private var searchOnTop: Bool = false
    @AppStorage("settings.displayOn") private var keepDisplayOn: Bool = false
    @AppStorage("currentVersion") private var currentVersion: String = "0.0.0"
    @AppStorage("globalVersion") private var globalVersion: String = "0.0.0"
    @AppStorage("welcome") private var welcome: Bool = false
    @AppStorage("settings.hiddenColor") var hiddenColor: Bool = false
    
    @State private var toBeUpdated: Bool = false
    @State private var settingsToOpen: Bool = false
    @State private var showWelcomePanel: Bool = false
    
    @State private var loadingDataRotation:Double = 0.0

    var body: some View {
        NavigationStack{
            VStack{
                if searchOnTop {
                    HStack{
                        TextField("Vyhledávání...", text: $searchKey)
                            .autocorrectionDisabled()
                            .padding(10)
                            .focused($searchFocused)
                        
                        if !searchKey.isEmpty {
                            Image(systemName: "x.circle.fill")
                                .onTapGesture {
                                    searchKey = ""
                                }
                                .opacity(0.7)
                        }
                    }
                    .padding(.horizontal, 10)
                    .disabled(!ready)
                    .opacity(ready ? 1 : 0.5)
                }
                
                if !ready{
                    VStack{
                        Image("MainLogoTransp")
                            .resizable()
                            .frame(width: loadingDataRotation > 0 ? 80 : 0, height: loadingDataRotation > 0 ? 80 : 0)
                            .background(hiddenColor ? Color.pink : (sc.settings.darkMode ? Color(red: 0.0, green: 0, blue: 0.0, opacity: 0.0) : Color("BasicColor")))
                            .cornerRadius(180)
                        
                        Text("Aktualní verze dat: \(currentVersion)")
                            .font(.subheadline)
                        Text("Verze ke stažení: \(globalVersion)")
                            .font(.headline)
                    }
                }
                
                LibraryView(searchKey: searchKey, favoritesOnly: onlyFavorites, fvm: fvm)
                    .tabItem {
                        Label("Knihovna", systemImage: "books.vertical.fill")
                    }
                    .tag("library")
                    .disabled(!ready)
                    .opacity(ready ? 1 : 0.5)
                
                if !searchOnTop {
                    HStack{
                        TextField("Vyhledávání...", text: $searchKey)
                            .autocorrectionDisabled()
                            .padding(10)
                            .focused($searchFocused)
                        
                        if !searchKey.isEmpty {
                            Image(systemName: "x.circle.fill")
                                .onTapGesture {
                                    searchKey = ""
                                }
                                .opacity(0.7)
                        }
                    }
                    .padding(.horizontal, 10)
                    .disabled(!ready)
                    .opacity(ready ? 1 : 0.5)
                }
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .onTapGesture {
                            Task {
                                await self.prepareData()
                            }
                        }
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(loadingDataRotation))
                        .animation(loadingDataRotation > 0 ? .linear(duration: 3).repeatForever(autoreverses: false) : .default, value: loadingDataRotation)
                        .disabled(!ready)
                        .padding(.horizontal, 2)
                        .imageScale(.large)
                        .scaleEffect(ready ? 1.1 : 1.5)
                        .overlay {
                            if globalVersion != currentVersion {
                                CustomBadgeView(imageSystem: "exclamationmark.circle", backgroundColor: Color(#colorLiteral(red: 0.09057433158, green: 0.1663101912, blue: 0.5200116038, alpha: 0.8707342791)))
                            }
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: onlyFavorites ? "heart.fill" : "heart")
                        .onTapGesture {
                            onlyFavorites.toggle()
                        }
                        .foregroundColor(Color(#colorLiteral(red: 0.6247290969, green: 0, blue: 0, alpha: 1)))
                        .disabled(!ready)
                        .opacity(ready ? 1 : 0.5)
                        .padding(.horizontal, 2)
                        .imageScale(.large)
                        .scaleEffect(1.1)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SubmenuView(settingsToOpen: $settingsToOpen, submenuViewOpened: $submenuViewOpened)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.secondary)
                            .disabled(!ready)
                            .opacity(ready ? 1 : 0.5)
                            .imageScale(.large)
                            .scaleEffect(1.1)
                    }
                    .isDetailLink(false)
                }
                
                if !networkController.connected {
                    ToolbarItem(placement: .status) {
                        HStack{
                            Text("Nejste připojen k Internetu")
                                .frame(width: 400, height: 25, alignment: .center)
                                .padding(2)
                                .background(Color("NetworkErrorColor"))
                                .cornerRadius(7)
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $urlViewModel.open) {
                if let item = urlViewModel.item {
                    ContentItemView(item: item)
                }
            }
        }
        .onAppear{
            UIApplication.shared.isIdleTimerDisabled = keepDisplayOn
        }
        .task {
            await self.isNewVersionDownloadable()
            
            if !welcome {
                welcome = true
                await self.prepareData()
            }
        }
        .onOpenURL { url in
            let str = url.absoluteString.replacingOccurrences(of: "kittapp://", with: "")
            
            let components = str.components(separatedBy: "?")
            
            for component in components {
                if component.contains("id="){
                    let rawValue = component.replacingOccurrences(of: "id=", with: "")
                    
                    if let found = items.first(where: { $0.id == rawValue }) {
                        urlViewModel.item = found
                        urlViewModel.open = true
                        urlViewModel.id = rawValue
                    }
                }
            }
        }
    }
    
    func isNewVersionDownloadable() async {
        if networkController.connected {
            let newestVersion = await VersionController().getNewestVersion()
            
            if newestVersion > currentVersion {
                globalVersion = newestVersion
            }
        }
    }
    
    func prepareData() async {
        loadingDataRotation = 360
        
        withAnimation(.easeInOut(duration: 0.5)) {
            ready = false
        }
        
        var isReady = false
        
        if !networkController.connected {
            isReady = true
        }else{
            
            await isNewVersionDownloadable()
            
            if let versionArray = await VersionController().loadVersionUpdates() {
                var read:Bool = false
                for item in versionArray {
                    read = false
                    if let versionExists = versions.first(where: {$0.version == item.version }){
                        read = versionExists.read
                    }
                    
                    let version = Version(context: dc.context)
                    version.version = item.version
                    version.content = item.news.joined(separator: "\n")
                    version.read = read
                }
            }
            
            let jsonController = JsonDataController()

            if let ciArray = await jsonController.downloadJsonData(.contentitem) as? Array<ItemModel> {
                for item in ciArray {
                    //prepare group
                    let group = Group(context: dc.context)
                    group.title = item.group

                    let new = ContentItem(context: dc.context)
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
                        dc.context.delete(item)
                    }
                }
            }
            
            dc.save()
            
            currentVersion = globalVersion
            
            isReady = true
        }
        
        withAnimation(.easeInOut(duration: 0.7)) {
            loadingDataRotation = 0.0
            ready = isReady
        }
        
        
        if ready{
            showWelcomePanel = !welcome
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
