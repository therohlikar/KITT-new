//
//  UrlViewModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 4/23/23.
//

import Foundation

class UrlViewModel: ObservableObject{
    @Published var id: String = ""
    @Published var open: Bool = false
    @Published var item: ContentItem? = nil
    
    init(){
        
    }
}
