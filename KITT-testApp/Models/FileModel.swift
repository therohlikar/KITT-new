//
//  FileModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 4/8/23.
//

import Foundation

struct FileModel: Codable, Hashable{
    var name: String = "items"
    var format: String = ".json"
    var comment: String = ""
    
    init(name: String, format: String, comment: String) {
        self.name = name
        self.format = format
        self.comment = comment
    }
}
