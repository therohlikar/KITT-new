//
//  FilterModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/5/23.
//

import Foundation

class FilterModel: Codable {
    enum specificType {
        case offense, crime, lawextract
    }
    
    var label: String = ""
    var key: String = ""
    var active: Bool = false
    var specific: String? = ""
    
    init(label: String, key: String, active: Bool, specific: String? = "") {
        self.label = label
        self.key = key
        self.active = active
        self.specific = specific
    }
}
