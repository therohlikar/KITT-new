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
    @StateObject private var networkController = NetworkController()
    @StateObject private var recentViewModel = RecentViewModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.context)
                .environmentObject(filterViewModel)
                .environmentObject(settingsController)
                .environmentObject(recentViewModel)
                .environmentObject(networkController)
                .environmentObject(dataController)
                .preferredColorScheme(settingsController.settings.darkMode ? .dark : .light)
                .autocorrectionDisabled(true)
        }
    }
}
