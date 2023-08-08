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
    @EnvironmentObject var fvm: FilterViewModel
    @EnvironmentObject var sc: SettingsController
    @EnvironmentObject var dc: DataController
    @EnvironmentObject var rvm: RecentViewModel
    @EnvironmentObject var gvm: GuideViewModel

    @AppStorage("currentVersion") private var dataVersion: String = "0.0.0"
    @AppStorage("settings.hiddenColor") private var hiddenColor: Bool = false
    @AppStorage("foundEasterEgg") private var foundEasterEgg: Bool = false
    
    let mailTo = Bundle.main.object(forInfoDictionaryKey: "MAIL_TO") as! String
    
    @State private var showingAlertRemoveData: Bool = false
    @State private var showingAlertGuideStarted: Bool = false
    
    var body: some View {
        ZStack{
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
                    
                    NavigationLink {
                        VisualThemeView()
                    } label: {
                        Text("Nastavení barevného motivu")
                    }
                }
                Section("SYSTÉM"){
                    if !gvm.beginGuide() {
                        Button {
                            gvm.startGuide()
                        } label: {
                            Text("Spustit průvodce")
                        }
                    }
            
                    NavigationLink {
                        FiltersList(fvm: fvm)
                    } label: {
                        Text("Nastavení filtrů vyhledávání")
                    }

                    Link(destination: URL(string: "mailto:\(mailTo)")!) {
                        Text("Napište mi")
                    }
                    
                    Button {
                        showingAlertRemoveData.toggle()
                    } label: {
                        Text("VYMAZAT DATA")
                    }
                    .foregroundColor(.red)
                }
            }
            .font(.caption)
            .tint(.blue)
            .alert("VYMAZAT DATA", isPresented: $showingAlertRemoveData) {
                Button("Smazat", role: .destructive) {
                    dataVersion = "0.0.0"
                    UserDefaults.standard.setValue(1, forKey: "currentGuideStep")
                    rvm.clearRecentItems()
                    
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
            .opacity(gvm.beginGuide() ? 0.5 : 1.0)
            .disabled(gvm.beginGuide())
            .navigationBarBackButtonHidden(gvm.beginGuide())
            
            if gvm.beginGuide(){
                VStack{
                    Spacer()
                    
                    GuideView()
                }
            }
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
