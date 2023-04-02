//
//  SettingsView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/7/23.
//

import SwiftUI
import MessageUI
import CoreData

struct SettingsView: View {
    @Binding var update: Bool
    @Binding var dismiss: Bool
    
    @EnvironmentObject var sc: SettingsController
    @EnvironmentObject var networkController: NetworkController
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "version", ascending: false)], predicate: NSPredicate(format: "read == 'false'")) var news: FetchedResults<Version>
    
    private var currentVersion:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    
    @AppStorage("currentVersion") private var dataVersion: String = "0.0.0"
    @AppStorage("settings.hiddenColor") private var hiddenColor: Bool = false
    @AppStorage("foundEasterEgg") private var foundEasterEgg: Bool = false
    
    let developer = Bundle.main.object(forInfoDictionaryKey: "DEVELOPER") as? String ?? "RJ"
    let developerLink = Bundle.main.object(forInfoDictionaryKey: "DEVELOPER_LINK") as? String ?? "rjwannabefit"
    let androidLink = Bundle.main.object(forInfoDictionaryKey: "KITT_ANDROID_LINK") as? String ?? "KITT"
    let mailTo = Bundle.main.object(forInfoDictionaryKey: "MAIL_TO") as! String
    
    @State private var showingNews: Bool = false
    @State private var showingCYC: Bool = false
    @State private var canSendMail: Bool = false
    @State private var showingAlertRemoveData: Bool = false
    
    public init (update: Binding<Bool>, isPresented: Binding<Bool>) {
        self._update = update
        self._dismiss = isPresented
    }

    var body: some View {
        VStack{
            VStack{
                Image("MainLogoTransp")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .background(hiddenColor ? Color.pink : (sc.settings.darkMode ? Color(red: 0.0, green: 0, blue: 0.0, opacity: 0.0) : Color("BasicColor")))
                    .cornerRadius(180)
                    .padding()
                    .onTapGesture(count: 10) {
                        if !foundEasterEgg{
                            foundEasterEgg = true
                            hiddenColor.toggle()
                            
                            UIApplication.shared.setAlternateIconName(hiddenColor ? "AlternativeAppIconPink" : nil)
                        }
                    }
                    .animation(.easeIn, value: hiddenColor)
                
                Link(destination: URL(string: developerLink)!) {
                    HStack{
                        Text(developer)
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
                
                Text("Verze: \(currentVersion)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Zákonná znění ve verzi: \(dataVersion)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Link(destination: URL(string: "mailto:\(mailTo)")!) {
                    HStack{
                        Text(mailTo)
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
                Link(destination: URL(string: "https://www.kittapp.store/")!) {
                    HStack{
                        Text("KITTAPP.STORE")
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
            }
            List{
                Section("OSTATNÍ"){
                    Button {
                        showingCYC.toggle()
                    } label: {
                        HStack{
                            Image("criminal")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Spacer()
                            
                            Text("CHYŤ SI SVÉHO ZLOČINCE")
                        }
                    }
                }
                Section("ÚPRAVA ROZHRANÍ"){
                    if foundEasterEgg{
                        HStack{
                            Text("EASTER EGG SPECIÁL")
                            Spacer()
                            Toggle("", isOn: $hiddenColor)
                                .onChange(of: hiddenColor) { value in
                                    UIApplication.shared.setAlternateIconName(value ? "AlternativeAppIconPink" : nil)
                                }
                                .labelsHidden()
                                
                        }
                    }
                    HStack{
                        Text("Tmavý režim")
                        Spacer()
                        Toggle("", isOn: $sc.settings.darkMode)
                            .labelsHidden()
                    }
                    
                    HStack{
                        Text("Zobrazovat detail v seznamu")
                        Spacer()
                        Toggle("", isOn: $sc.settings.showDetail)
                            .labelsHidden()
                    }
                    
                    HStack{
                        Text("Pole pro vyhledávání")
                        Spacer()
                        Picker("", selection: $sc.settings.searchOnTop) {
                            Text("Nahoře")
                                .tag(true)
                            Text("Dole")
                                .tag(false)
                        }
                        .labelsHidden()
                    }
                }
                Section("UKLÁDÁNÍ DAT"){
                    HStack{
                        Text("Ukládat poznámky automaticky")
                        Spacer()
                        Toggle("", isOn: $sc.settings.saveNotes)
                            .labelsHidden()
                    }
                    
                    HStack{
                        Text("Ukládat filtry")
                        Spacer()
                        Toggle("", isOn: $sc.settings.saveFilters)
                            .labelsHidden()
                    }
                }
                Section("SYSTÉM"){
                    Button {
                        showingNews.toggle()
                    } label: {
                        Text("NOVINKY")
                    }
                    .badge(news.count)
                    
                    Link(destination: URL(string: "mailto:\(mailTo)")!) {
                        Text("NAPIŠTE MI")
                    }
                    
                    Button {
                        dataVersion = "0.0.0"
                        self.update = true
                        self.dismiss = false
                    } label: {
                        Text("AKTUALIZACE DAT")
                    }
                    Button {
                        showingAlertRemoveData.toggle()
                    } label: {
                        Text("VYMAZAT DATA")
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .font(.caption)
        .preferredColorScheme(sc.settings.darkMode ? .dark : .light)
        .tint(.blue)
        .sheet(isPresented: $showingNews) {
            NewsView()
                .preferredColorScheme(sc.settings.darkMode ? .dark : .light)
        }
        .fullScreenCover(isPresented: $showingCYC) {
            CYCMenuView(showingCYC: $showingCYC)
        }
        .alert("VYMAZAT DATA", isPresented: $showingAlertRemoveData) {
            Button("Smazat", role: .destructive) {
                dataVersion = "0.0.0"
                
                if self.removeAll(){
                    exit(0)
                }
            }
            
            Button("Zrušit", role: .cancel) {
                showingAlertRemoveData = false
            }
        } message: {
            Text("Jste si jistý, že chcete vymazat data?\nVymazání dat způsobí smazání všech aktuálních dat vč. poznámek a oblíbených. \nAplikace bude po souhlasu ukončena.")
        }
    }
    
    func removeAll() -> Bool {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "ContentItem")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try moc.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            fatalError("\(error.localizedDescription)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Version")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try moc.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            fatalError("\(error.localizedDescription)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Group")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try moc.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            fatalError("\(error.localizedDescription)")
        }
        
        return true
    }
}
