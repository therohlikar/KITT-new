//
//  FilterViewModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/5/23.
//

import Foundation

class FilterViewModel: ObservableObject{
    @Published var filters: [FilterModel] = []
    
    init(){
        decodeLocalFilters()
    }

    func decodeLocalFilters(){
        if UserDefaults.standard.data(forKey: "settings.filters") == nil {
            filters = [
                FilterModel(label: "Název", key: "title", active: true),
                FilterModel(label: "Zákonné znění", key: "content", active: true),
                FilterModel(label: "§ Skutku", key: "paragraph", active: true),
                FilterModel(label: "§ Přestupku (BESIP)", key: "violationParagraph", active: true, specific: "offense"),
                FilterModel(label: "Možnosti řešení", key: "resolveOptions", active: true, specific: "offense"),
                FilterModel(label: "Poznámka", key: "note", active: false)
            ]
            
            encodeLocalFilters()
        }
        
        guard
            let data = UserDefaults.standard.data(forKey: "settings.filters"),
            let decodedFilters = try? JSONDecoder().decode([FilterModel].self, from: data)
        else {
            return
        }
        
        self.filters = decodedFilters
    }
    
    func encodeLocalFilters(){
        if let encoded = try? JSONEncoder().encode(filters){
            UserDefaults.standard.setValue(encoded, forKey: "settings.filters")
        }
    }
}
