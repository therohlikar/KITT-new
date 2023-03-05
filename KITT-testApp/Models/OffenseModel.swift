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
        "title":"Technický stav",
        "content":"(1) Fyzická osoba se dopustí přestupku tím, že v provozu na pozemních komunikacích a) řídí vozidlo, k) jiným jednáním, než které je uvedeno pod písmeny a) až j), nesplní nebo poruší povinnost stanovenou v hlavě II tohoto zákona.",
        "lawNumber": 361,
        "lawYear": 2000,
        "paragraph": "5/1/a",
        "violationLawNumber": 361,
        "violationLawYear": 2000,
        "violationParagraph": "125c odst. 1 pism. k)",
        "resolveOptions": "Příkazem na místě od 100 CZK do 2000 CZK.\nOznámením.\nDomluvou.",
        "offenseScore": 0,
        "isOffenseTracked": false,
        "fineExample": "Dne DD.MM.YYYY v HH:MM na ul. ULICE, MĚSTO užil jako řidič vozidlo nesplňující technický stav, čímž porušil §5/1a) z. č. 361/2000 Sb.",
        "note": "",
        "isFavorited": false
    },
    {
         "title":"Technický stav",
         "content":"(1) Fyzická osoba se dopustí přestupku tím, že v provozu na pozemních komunikacích a) řídí vozidlo, k) jiným jednáním, než které je uvedeno pod písmeny a) až j), nesplní nebo poruší povinnost stanovenou v hlavě II tohoto zákona.",
         "lawNumber": 999,
         "lawYear": 2000,
         "paragraph": "5 odst. 1 pism. a)",
         "violationLawNumber": 361,
         "violationLawYear": 2000,
         "violationParagraph": "125c odst. 1 pism. k)",
         "resolveOptions": "Příkazem na místě od 100 CZK do 2000 CZK.\nOznámením.\nDomluvou.",
         "offenseScore": 0,
         "isOffenseTracked": false,
         "fineExample": "Dne DD.MM.YYYY v HH:MM na ul. ULICE, MĚSTO užil jako řidič vozidlo nesplňující technický stav, čímž porušil §5/1a) z. č. 361/2000 Sb.",
         "note": "",
         "isFavorited": false
    },
    {
         "title":"Technický stav",
         "content":"(1) Fyzická osoba se dopustí přestupku tím, že v provozu na pozemních komunikacích a) řídí vozidlo, k) jiným jednáním, než které je uvedeno pod písmeny a) až j), nesplní nebo poruší povinnost stanovenou v hlavě II tohoto zákona.",
         "lawNumber": 888,
         "lawYear": 2000,
         "paragraph": "5 odst. 1 pism. a)",
         "violationLawNumber": 361,
         "violationLawYear": 2000,
         "violationParagraph": "125c odst. 1 pism. k)",
         "resolveOptions": "Příkazem na místě od 100 CZK do 2000 CZK.\nOznámením.\nDomluvou.",
         "offenseScore": 0,
         "isOffenseTracked": false,
         "fineExample": "Dne DD.MM.YYYY v HH:MM na ul. ULICE, MĚSTO užil jako řidič vozidlo nesplňující technický stav, čímž porušil §5/1a) z. č. 361/2000 Sb.",
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
    var note: String = ""
    var isFavorited: Bool = false
}
