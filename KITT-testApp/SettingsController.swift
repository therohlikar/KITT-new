//
//  SettingsController.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//

import Foundation
/**
    Class manages user's settings.
 */
class SettingsController: ObservableObject{
    @Published var settings = SettingsModel()
}
