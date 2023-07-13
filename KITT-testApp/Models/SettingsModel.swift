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
    var keepDisplayOn: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "settings.keepDisplayOn")
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "settings.keepDisplayOn")
        }
    }
}
