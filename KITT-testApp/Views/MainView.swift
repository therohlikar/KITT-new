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
    @EnvironmentObject var sc: SettingsController
    @EnvironmentObject var dc: DataController
    @EnvironmentObject var gvm: GuideViewModel
    
    @ObservedObject var urlViewModel: UrlViewModel = UrlViewModel()
    
    @FetchRequest(sortDescriptors: []) var groups: FetchedResults<Group>
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<ContentItem>
    @FetchRequest(sortDescriptors: []) var versions: FetchedResults<Version>
    
    @State private var isAllowedToUseApp: Bool = true
    @State private var searchKey: String = ""
    @State private var onlyFavorites: Bool = false
    @State private var isSearchVisible: Bool = false
    @State private var searchBarOpacity: Double = 0.6
    
    @FocusState private var searchFocused: Bool
    
    @AppStorage("settings.displayOn") private var keepDisplayOn: Bool = false
    @AppStorage("currentVersion") private var currentVersion: String = "0.0.0"
    @AppStorage("remoteVersion") private var remoteVersion: String = "0.0.0"
    @AppStorage("settings.hiddenColor") var hiddenColor: Bool = false
    
    @State private var loadingDataRotation:Double = 0.0

    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    if !isAllowedToUseApp{
                        VStack{
                            Image("MainLogoTransp")
                                .resizable()
                                .frame(width: loadingDataRotation > 0 ? 80 : 0, height: loadingDataRotation > 0 ? 80 : 0)
                                .background(hiddenColor ? Color.pink : (sc.settings.darkMode ? Color(red: 0.0, green: 0, blue: 0.0, opacity: 0.0) : Color("BasicColor")))
                                .cornerRadius(180)
                            
                            Text("Aktualní verze dat: \(currentVersion)")
                                .font(.subheadline)
                            Text(NetworkController.network.connected ? ("Verze ke stažení: \(remoteVersion)") : "Nejste připojen k internetu")
                                .font(.headline)
                        }
                    }
                    
                    LibraryView(searchKey: searchKey, favoritesOnly: onlyFavorites, fvm: fvm)
                        .tabItem {
                            Label("Knihovna", systemImage: "books.vertical.fill")
                        }
                        .tag("library")
                        .disabled(isDisabled())
                        .opacity(!isDisabled() ? 1 : 0.5)
                }
                .edgesIgnoringSafeArea(.bottom)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink {
                            RecentListView()
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(.blue)
                                .opacity(!isDisabled() ? 1 : 0.5)
                                .imageScale(.large)
                                .scaleEffect(1.1)
                        }
                        .disabled(isDisabled())
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .onTapGesture {
                                if isSearchVisible {
                                    withAnimation(.spring()) {
                                        isSearchVisible = false
                                    }
                                    
                                    withAnimation(.easeInOut(duration: 1.5)) {
                                        searchBarOpacity = 0.6
                                    }
                                }
                                
                                Task {
                                    await self.prepareData()
                                }
                            }
                            .foregroundColor(.secondary)
                            .rotationEffect(.degrees(loadingDataRotation))
                            .animation(loadingDataRotation > 0 ? .linear(duration: 3).repeatForever(autoreverses: false) : .default, value: loadingDataRotation)
                            .disabled(isDisabled())
                            .opacity(!isDisabled() ? 1.0 : 0.5)
                            .padding(.horizontal, 2)
                            .imageScale(.large)
                            .scaleEffect(!isAllowedToUseApp ? 1.5 : 1.1)
                            .overlay {
                                if !NetworkController.network.connected{
                                    CustomBadgeView(imageSystem: "exclamationmark.circle", backgroundColor: Color(#colorLiteral(red: 0.6157925129, green: 0, blue: 0, alpha: 1)), size: 0, hPosition: [.top, .bottom], vPosition: [.trailing, .trailing], hOffset: 0.2, vOffset: 2.8)
                                }
                                
                                if remoteVersion != currentVersion {
                                    CustomBadgeView(imageSystem: "exclamationmark.circle", backgroundColor: Color(#colorLiteral(red: 0.09057433158, green: 0.1663101912, blue: 0.5200116038, alpha: 0.8707342791)), size: 0, hPosition: [.top, .bottom], vPosition: [.trailing, .trailing], hOffset: 0.2, vOffset: 0.4)
                                }
                            }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: onlyFavorites ? "heart.fill" : "heart")
                            .onTapGesture {
                                onlyFavorites.toggle()
                            }
                            .foregroundColor(Color(#colorLiteral(red: 0.6247290969, green: 0, blue: 0, alpha: 1)))
                            .disabled(isDisabled())
                            .opacity(!isDisabled() ? 1 : 0.5)
                            .padding(.horizontal, 2)
                            .imageScale(.large)
                            .scaleEffect(1.1)
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SubmenuView()
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(.secondary)
                                .opacity(!isDisabled() ? 1 : 0.5)
                                .imageScale(.large)
                                .scaleEffect(1.1)
                        }
                        .isDetailLink(false)
                        .disabled(isDisabled())
                    }
                }
                .navigationDestination(isPresented: $urlViewModel.open) {
                    if let item = urlViewModel.item {
                        ContentItemView(item: item)
                    }
                }
                
                if gvm.beginGuide(){
                    VStack{
                        Spacer()
                        
                        GuideView()
                    }
                }
            }
            .overlay(alignment: .bottomTrailing, content: {
                HStack{
                    Image(systemName: "magnifyingglass.circle")
                        .font(.system(size: 38))
                        .foregroundColor(Color("ItemRowMenuColor"))
                        .onTapGesture {
                            searchBarOpacity = 0.9
                            
                            withAnimation(.spring()) {
                                isSearchVisible.toggle()
                            }
                            
                            if !isSearchVisible {
                                searchBarOpacity = 0.6
                            }
                            else{
                                searchFocused.toggle()
                            }
                        }
                        .offset(x: !isSearchVisible ? 0 : 30, y: 0)
                    
                    if isSearchVisible {
                        VStack (alignment: .leading){
                            TextField("", text: $searchKey.max(22))
                                .foregroundColor(Color("ItemRowMenuColor"))
                                .offset(x: !isSearchVisible ? 0 : 30, y: 0)
                                .focused($searchFocused)
                            
                            Rectangle()
                                .frame(width: 250, height: 2)
                                .foregroundColor(Color("ItemRowMenuColor"))
                                .offset(x: !isSearchVisible ? 0 : 30, y: 0)
                                .opacity(0.6)
                        }
                        
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: !isSearchVisible ? 50 : 25)
                        .fill(Color("BasicColor"))
                        .frame(width: !isSearchVisible ? 75 : 355, height: 75)
                )
                .overlay{
                    if !isSearchVisible && !searchKey.isEmpty {
                        CustomBadgeView(imageSystem: "xmark.circle", backgroundColor: Color(#colorLiteral(red: 0.6157925129, green: 0, blue: 0, alpha: 1)), size: 16, hPosition: [.top, .bottom], vPosition: [.trailing, .trailing], hOffset: 0.2, vOffset: 2.8)
                            .onTapGesture {
                                searchKey = ""
                            }
                    }
                }
                .opacity(isDisabled() ? 0.0 : searchBarOpacity)
                .offset(x: !isSearchVisible ? -40 : 0, y: -15)
                .disabled(isDisabled())
            })
        }
        .onAppear{
            UIApplication.shared.isIdleTimerDisabled = keepDisplayOn
        }
        .task {
            _ = await VersionController.controller.isDataUpToDate()
            
            if gvm.beginGuide() {
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
    

    func isDisabled() -> Bool {
        if gvm.beginGuide() || !isAllowedToUseApp {
            return true
        }
        return false
    }
    
    func prepareData() async {
        loadingDataRotation = 360
        
        withAnimation(.easeInOut(duration: 0.5)) {
            isAllowedToUseApp = false
        }
        
        var isReady = false
        
        if !NetworkController.network.connected {
            isReady = true
        }else{
            if await VersionController.controller.isDataUpToDate() {
                let _ = await VersionController.controller.getVersionNews(dc)
            }

            let itemArray = await JsonDataController.controller.getRemoteContent(dc)
            
            for item in items {
                if !itemArray.contains(where: {$0.id == item.wrappedId}){
                    dc.context.delete(item)
                }
            }
            
            let _ = await dc.clearItemDuplicates(items: itemArray)
            
            isReady = true
        }
        
        withAnimation(.easeInOut(duration: 0.7)) {
            loadingDataRotation = 0.0
            isAllowedToUseApp = isReady
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
