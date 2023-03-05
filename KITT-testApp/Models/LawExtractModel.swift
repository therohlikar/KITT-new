//
//  LawExtract.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import Foundation

/*
LAW EXTRACT = vytazek ze zakona
[



]
*/
struct LawExtractModel {
   var id: String = "LE" //LE + shortKeyWord (fe: "LEfreedomRestriction)
   var title: String? = ""
   var description: String? = ""
   var note: String? = ""
   var isFavorited: Bool = false
}
