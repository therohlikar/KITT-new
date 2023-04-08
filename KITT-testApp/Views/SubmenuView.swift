//
//  SubmenuView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 4/8/23.
//

import SwiftUI

struct SubmenuView: View {
    @State private var showingCYC: Bool = false
    
    @Binding var settingsToOpen: Bool
    @Binding var submenuViewOpened: Bool
    
    var body: some View {
        List{
            Button {
                settingsToOpen = true
                submenuViewOpened = false
            } label: {
                HStack{
                    Image(systemName: "gearshape.fill")
                    
                    Text("Nastavení")
                }
                
            }
            
            Section {
                Button {
                    showingCYC.toggle()
                } label: {
                    HStack{
                        Image(systemName: "gamecontroller.fill")
                        
                        Text("CHYŤ SI SVÉHO ZLOČINCE")
                    }
                }
            } header: {
                Text("OSTATNÍ")
            }
        }
        .fullScreenCover(isPresented: $showingCYC) {
            CYCMenuView(showingCYC: $showingCYC)
        }
        .foregroundColor(.primary)
        .padding()
    }
}
