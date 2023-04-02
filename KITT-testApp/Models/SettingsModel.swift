//
//  SettingsModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/6/23.
//

import Foundation


struct SettingsModel {
    var darkMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "settings.darkMode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "settings.darkMode")
        }
    }
    var saveFilters: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "settings.saveFilters")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "settings.saveFilters")
        }
    }
    var saveNotes: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "settings.saveNotes")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "settings.saveNotes")
        }
    }
    var downloadDataOnStartup: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "settings.downloadDataOnStartup")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "settings.downloadDataOnStartup")
        }
    }
    var showDetail: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "settings.showDetail")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "settings.showDetail")
        }
    }
    var searchOnTop: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "settings.searchOnTop")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "settings.searchOnTop")
        }
    }
}
