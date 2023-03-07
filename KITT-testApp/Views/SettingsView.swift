//
//  SettingsView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/7/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sc: SettingsController
    
    var body: some View {
        VStack{
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
                        Text("Uložit poznámku automaticky")
                        Spacer()
                        Toggle("", isOn: $sc.settings.saveNotes)
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
