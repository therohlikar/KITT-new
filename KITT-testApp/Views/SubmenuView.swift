//
//  SubmenuView.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 4/8/23.
//

import SwiftUI

struct SubmenuView: View {
    @Binding var settingsToOpen: Bool
    @Binding var submenuViewOpened: Bool
    
    @EnvironmentObject var sc: SettingsController
    
    @State var showingCYC: Bool = false
    var appVersion:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    
    @AppStorage("currentVersion") var dataVersion: String = "0.0.0"
    @AppStorage("settings.hiddenColor") var hiddenColor: Bool = false
    @AppStorage("foundEasterEgg") var foundEasterEgg: Bool = false
    
    let developer = Bundle.main.object(forInfoDictionaryKey: "DEVELOPER") as? String ?? "RJ"
    let developerLink = Bundle.main.object(forInfoDictionaryKey: "DEVELOPER_LINK") as? String ?? "rjwannabefit"
    let androidLink = Bundle.main.object(forInfoDictionaryKey: "KITT_ANDROID_LINK") as? String ?? "KITT"
    let mailTo = Bundle.main.object(forInfoDictionaryKey: "MAIL_TO") as! String
    
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
                
                Text("Verze: \(appVersion)")
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
                Link(destination: URL(string: "https://www.kittapp.store/www/files/iOS_tutorial.pdf")!) {
                    HStack{
                        Text("TUTORIAL")
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                    }
                    .foregroundColor(.secondary)
                    .font(.caption)
                }
            }
            
            List{
                NavigationLink {
                    SettingsView()
                } label: {
                    HStack{
                        Image(systemName: "gearshape.fill")
                        
                        Text("Nastavení")
                    }
                }
                .isDetailLink(false)
                
                NavigationLink{
                    CYCMenuView(showingCYC: $showingCYC)
                } label: {
                    HStack{
                        Image(systemName: "gamecontroller.fill")
                        
                        Text("CHYŤ SI SVÉHO ZLOČINCE")
                    }
                }
                .isDetailLink(false)
            }
            .cornerRadius(12)
        }
        .font(.caption)
        .foregroundColor(.primary)
        .padding()
    }
}
