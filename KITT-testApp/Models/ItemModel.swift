//
//  ItemModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/29/23.
//

import Foundation

struct ItemModel: Codable, Hashable {
    var id: String? = ""
    var group: String? = "Nezařazeno"
    var subgroup: String? = "Nezařazeno"
    var type: String? = "offense"
    var title: String? = ""
    var content: String? = ""
    var keywords: String? = ""
    var warning: String? = ""
    var miranda: String? = ""
    var sanctions: String? = ""
    var links: String? = ""
}