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
        if UserDefaults.standard.data(forKey: "filters") == nil {
            filters = [
                FilterModel(label: "Název", key: "title", active: true),
                FilterModel(label: "Zákonné znění", key: "content", active: true),
                FilterModel(label: "§ Porušení", key: "paragraph", active: true),
                FilterModel(label: "§ Přestupku (BESIP)", key: "violationParagraph", active: true),
                FilterModel(label: "Možnosti řešení", key: "resolveOptions", active: true),
                FilterModel(label: "Příklad příkazového bloku", key: "fineExample", active: true),
                FilterModel(label: "Poznámka", key: "note", active: false)
            ]
            
            encodeLocalFilters()
        }
        
        guard
            let data = UserDefaults.standard.data(forKey: "filters"),
            let decodedFilters = try? JSONDecoder().decode([FilterModel].self, from: data)
        else {
            return
        }
        
        self.filters = decodedFilters
    }
    
    func encodeLocalFilters(){
        if let encoded = try? JSONEncoder().encode(filters){
            UserDefaults.standard.setValue(encoded, forKey: "filters")
        }
    }
}
