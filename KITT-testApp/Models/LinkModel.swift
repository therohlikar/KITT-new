//
//  LinkModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/31/23.
//

import Foundation

struct LinkModel: Codable, Hashable {
    var title: String
    var link: String
    
    init(title: String, link: String) {
        self.title = title
        self.link = link
    }
}
