//
//  Offense.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import Foundation

struct OffenseModel: Codable, Hashable {
    var id: String? = "" //=paragraph basically (the most unique id)
    var groups: [String] = ["Nezařazeno"]
    var title: String = ""
    var content: String = ""
    var paragraph: String = "273-2008-114-1"
    var violationParagraph: String? = nil
    var resolveOptions: String = ""
    var offenseScore: Int = 0
    var isOffenseTracked: Bool = false
    var fineExample: String = ""
    var warning: String? = nil
    var miranda: String? = nil
    var note: String = ""
    var isFavorited: Bool = false
}
