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
    let developer = Bundle.main.object(forInfoDictionaryKey: "DEVELOPER") as? String ?? "RJ"
    let developerLink = Bundle.main.object(forInfoDictionaryKey: "DEVELOPER_LINK") as? String ?? "rjwannabefit"
    let androidLink = Bundle.main.object(forInfoDictionaryKey: "KITT_ANDROID_LINK") as? String ?? "KITT"
    
    var body: some View {
        VStack{
            VStack{
                Image("MainLogoTransp")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .background(sc.settings.darkMode ? nil : Color("BasicColor"))
                    .cornerRadius(180)
                    .padding()
                
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
                Link(destination: URL(string: androidLink)!) {
                    HStack{
                        Text("Android verze ke stažení")
                        Image(systemName: "link")
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
            }
            
            
//            Section("O APLIKACI"){
//                HStack{
//                    Text("Autor")
//                        .font(.headline)
//                    Spacer()
//                    Button("Radek Jeník, 2023 (@rjwannabefit)") {
//                        // send mail
//                    }.font(.caption)
//                }
//
//                HStack{
//                    Text("Spolupráce")
//                        .font(.headline)
//                    Spacer()
//                    Text("Android KITT app")
//                        .font(.caption)
//                }
//
//                HStack{
//                    Text("Verze")
//                        .font(.headline)
//                    Spacer()
//                    Text("\(version ?? "BETA")")
//                        .font(.caption)
//                }
//            }
            
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
            }
        }
        .font(.caption)
        .preferredColorScheme(sc.settings.darkMode ? .dark : .light)
        .tint(.blue)
    }
}
