//
//  Offense.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import Foundation

/*
OFFENSE = prestupek
[
 {
     "groups":["BESIP"],
     "title":"TechnickÃ½ stav",
     "content":"(1) FyzickÃ¡ osoba se dopustÃ­ pÅ™estupku tÃ­m, Å¾e v provozu na pozemnÃ­ch komunikacÃ­ch a) Å™Ã­dÃ­ vozidlo, k) jinÃ½m jednÃ¡nÃ­m, neÅ¾ kterÃ© je uvedeno pod pÃ­smeny a) aÅ¾ j), nesplnÃ­ nebo poruÅ¡Ã­ povinnost stanovenou v hlavÄ› II tohoto zÃ¡kona.",
     "paragraph": "361-2000-5-1-a",
     "violationParagraph": "361-2000-125c-1-k",
     "resolveOptions": "BPR 100 - 1000\nOznameni",
     "offenseScore": 0,
     "isOffenseTracked": false,
     "fineExample": "Dne DD.MM.YYYY v HH:MM na ul. ULICE, MÄšSTO uÅ¾il jako Å™idiÄ vozidlo nesplÅˆujÃ­cÃ­ technickÃ½ stav, ÄÃ­mÅ¾ poruÅ¡il Â§5/1a) z. Ä. 361/2000 Sb.",
     "note": "",
     "isFavorited": false
 
 }
]
*/

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
