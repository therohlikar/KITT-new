//
//  VersionModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//

import Foundation

struct VersionModel: Codable, Hashable{
    var version: String = "0.0.0"
    var news: [String] = []
}
