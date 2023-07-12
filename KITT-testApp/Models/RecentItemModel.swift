//
//  RecentItemModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/12/23.
//

import Foundation

struct RecentItemModel:Codable, Hashable{
    var id: String
    var opened: Date
    
    init(id: String, opened: Date) {
        self.id = id
        self.opened = opened
    }
}
