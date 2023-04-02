//
//  ContentModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/31/23.
//

import Foundation

struct ContentModel: Codable, Hashable {
    var title: String
    var link: String = ""
    var content: String
    
    init(title: String, link: String, content: String) {
        self.title = title
        self.link = link
        self.content = content
    }
}
