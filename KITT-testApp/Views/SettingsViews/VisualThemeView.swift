//
//  VisualThemeView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/13/23.
//

import SwiftUI

struct VisualThemeView: View {
    @EnvironmentObject var sc: SettingsController
    
    var body: some View {
        HStack{
            Image("LightThemeImage")
                .resizable()
                .scaledToFill()
                .padding(sc.settings.darkMode ? 0 : 4)
                .background(
                    Color.blue
                )
                .cornerRadius(7)
                .onTapGesture {
                    sc.settings.darkMode = false
                }
                .offset(x: sc.settings.darkMode ? -50 : 50)
                
            
            Image("DarkThemeImage")
                .resizable()
                .scaledToFill()
                .padding(sc.settings.darkMode ? 4 : 0)
                .background(
                    Color.blue
                )
                .cornerRadius(7)
                .onTapGesture {
                    sc.settings.darkMode = true
                }
                .offset(x: sc.settings.darkMode ? -50 : 50)
        }
        .cornerRadius(7)
        .padding()
    }
}

struct VisualThemeView_Previews: PreviewProvider {
    static var previews: some View {
        VisualThemeView()
    }
}
