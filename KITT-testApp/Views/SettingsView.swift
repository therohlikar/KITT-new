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
    @EnvironmentObject var sc: SettingsController
    @EnvironmentObject var dc: DataController
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "version", ascending: false)], predicate: NSPredicate(format: "read == 'false'")) var news: FetchedResults<Version>

    @AppStorage("currentVersion") private var dataVersion: String = "0.0.0"
    @AppStorage("settings.hiddenColor") private var hiddenColor: Bool = false
    @AppStorage("foundEasterEgg") private var foundEasterEgg: Bool = false
    @AppStorage("welcome") private var welcome: Bool = false
    
    let mailTo = Bundle.main.object(forInfoDictionaryKey: "MAIL_TO") as! String
    
    @State private var canSendMail: Bool = false
    @State private var showingAlertRemoveData: Bool = false

    var body: some View {
        VStack{
            List{
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
                        Text("Vypnout usínání displeje při prohlížení")
                        Spacer()
                        Toggle("", isOn: $sc.settings.keepDisplayOn)
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
                Section("SYSTÉM"){
                    NavigationLink {
                        NewsView()
                    } label: {
                        if news.count > 0 {
                            Text("NOVINKY (\(news.count))")
                                .foregroundColor(.blue)
                        }else {
                            Text("NOVINKY")
                                .foregroundColor(.blue)
                        }
                        
                    }
                    
                    Link(destination: URL(string: "mailto:\(mailTo)")!) {
                        Text("NAPIŠTE MI")
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
        .alert("VYMAZAT DATA", isPresented: $showingAlertRemoveData) {
            Button("Smazat", role: .destructive) {
                dataVersion = "0.0.0"
                welcome = false
                
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
            try dc.context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            fatalError("\(error.localizedDescription)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Version")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try dc.context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            fatalError("\(error.localizedDescription)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Group")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try dc.context.execute(deleteRequest)
        } catch let error as NSError {
            // TODO: handle the error
            fatalError("\(error.localizedDescription)")
        }
        
        return true
    }
}
