//
//  LawExtract.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import Foundation

struct LawExtractModel: Codable, Hashable {
    var id: String? = "" //=paragraph basically (the most unique id)
    var groups: [String] = ["Nezařazeno"]
    var title: String? = ""
    var paragraph: String? = ""
    var content: String? = ""
    var warning: String? = nil
    var miranda: String? = nil
    var note: String = ""
    var isFavorited: Bool = false
}
