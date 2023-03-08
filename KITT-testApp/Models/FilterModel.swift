//
//  FilterModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/5/23.
//

import Foundation

class FilterModel: Codable {
    var label: String = ""
    var key: String = ""
    var active: Bool = false
    
    init(label: String, key: String, active: Bool) {
        self.label = label
        self.key = key
        self.active = active
    }
}
