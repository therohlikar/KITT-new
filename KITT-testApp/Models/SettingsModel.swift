//
//  SettingsModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/6/23.
//

import Foundation


struct SettingsModel {
    let defaultPanel: String = "library"
    
    var darkMode: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "darkMode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "darkMode")
        }
    }
    var saveFilters: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "saveFilters")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "saveFilters")
        }
    }
    var saveNotes: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "saveNotes")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "saveNotes")
        }
    }
    var downloadDataOnStartup: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "downloadDataOnStartup")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "downloadDataOnStartup")
        }
    }
    var showDetail: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "showDetail")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "showDetail")
        }
    }
    var preferredPanel: String {
        get {
            return UserDefaults.standard.string(forKey: "preferredPanel") ?? defaultPanel
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "preferredPanel")
        }
    }
}
