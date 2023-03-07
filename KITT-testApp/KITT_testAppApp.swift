//
//  KITT_testAppApp.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import SwiftUI

@main
struct KITT_testAppApp: App {
    @StateObject private var dataController = DataController()
    @StateObject private var filterViewModel = FilterViewModel()
    @StateObject private var settingsController = SettingsController()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(filterViewModel)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(settingsController.settings.darkMode ? .dark : .light)
                .environmentObject(settingsController)
        }
    }
}
