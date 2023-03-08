//
//  SettingsView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/7/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sc: SettingsController
    
    private var currentVersion:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    
    @AppStorage("currentVersion") private var dataVersion: String = "0.0.0"
    @AppStorage("hiddenColor") private var hiddenColor: Bool = false
    
    let developer = Bundle.main.object(forInfoDictionaryKey: "DEVELOPER") as? String ?? "RJ"
    let developerLink = Bundle.main.object(forInfoDictionaryKey: "DEVELOPER_LINK") as? String ?? "rjwannabefit"
    let androidLink = Bundle.main.object(forInfoDictionaryKey: "KITT_ANDROID_LINK") as? String ?? "KITT"
    
    @State private var showingNews: Bool = false
    
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
                        hiddenColor.toggle()
                    }
                    .onLongPressGesture(minimumDuration: 3.0, perform: {
                        hiddenColor.toggle()
                    })
                    .animation(.easeIn, value: hiddenColor)
                
                Link(destination: URL(string: developerLink)!) {
                    HStack{
                        Text(developer)
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
                
                Text("Verze: \(currentVersion)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Zákony: \(dataVersion >= VersionController().newestVersion ? "Aktualizováno" : "Verze dat není správná")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Link(destination: URL(string: androidLink)!) {
                    HStack{
                        Text("Android verze ke stažení")
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
            }
            List{
                Section("ÚPRAVA ROZHRANÍ"){
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
                        Text("Preferovaný panel při otevření")
                        Spacer()
                        Picker("", selection: $sc.settings.preferredPanel) {
                            Text("Knihovna")
                                .tag("library")
                            Text("Oblíbené")
                                .tag("favorites")
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
                Button("NOVINKY") {
                    showingNews.toggle()
                }
            }
        }
        .font(.caption)
        .preferredColorScheme(sc.settings.darkMode ? .dark : .light)
        .tint(.blue)
        .sheet(isPresented: $showingNews) {
            NewsView()
        }
    }
}
