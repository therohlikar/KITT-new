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
    @StateObject private var recentViewModel = RecentViewModel()
    @StateObject private var guideViewModel = GuideViewModel()
    @StateObject private var networkController = NetworkController()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.context)
                .environmentObject(guideViewModel)
                .environmentObject(filterViewModel)
                .environmentObject(settingsController)
                .environmentObject(recentViewModel)
                .environmentObject(dataController)
                .preferredColorScheme(settingsController.settings.darkMode ? .dark : .light)
                .autocorrectionDisabled(true)
        }
    }
}
