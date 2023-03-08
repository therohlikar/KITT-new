//
//  Crime.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import Foundation

/*
CRIME = trestny cin
[
 
 
 
]
 */
struct CrimeModel: Codable, Hashable {
    var id: String? = "" //=paragraph basically (the most unique id)
    var groups: [String] = ["Nezařazeno"]
    var title: String = ""
    var description: String? = ""
    var paragraph: String? = "273-2008-114-1"
    var crimeExample: String? = ""
    var note: String? = ""
    var isFavorited: Bool = false
}
