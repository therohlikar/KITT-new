//
//  SanctionModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/31/23.
//

import Foundation

struct SanctionModel: Codable, Hashable {
    var title: String
    var content: String
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
