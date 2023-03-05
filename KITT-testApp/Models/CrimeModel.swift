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
struct CrimeModel {
    var id: String = "" //lawNumber + lawYear + paragraph
    var title: String = ""
    var description: String? = ""
    var lawNumber: Int? = 273
    var lawYear: Int? = 2008
    var paragraph: String? = "114"
    var crimeExample: String? = ""
    var note: String? = ""
    var isFavorited: Bool = false
}
