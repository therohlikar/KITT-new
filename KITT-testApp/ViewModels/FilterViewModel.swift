//
//  FilterViewModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/5/23.
//

import Foundation

class FilterViewModel: ObservableObject{
    @Published var offenseFilters: [FilterModel] = [
        FilterModel(label: "Title", key: "title", active: true),
        FilterModel(label: "Description", key: "content", active: true),
        FilterModel(label: "Paragraph", key: "paragraph", active: true),
        FilterModel(label: "ViolationParagraph", key: "violationParagraph", active: true),
        FilterModel(label: "ResolveOptions", key: "resolveOptions", active: true),
        FilterModel(label: "FineExample", key: "fineExample", active: true),
        FilterModel(label: "Note", key: "note", active: true)
    ]
    
    init(){
        
    }
}
