//
//  RecentViewModel.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 7/12/23.
//

import Foundation

class RecentViewModel: ObservableObject{
    @Published var recentItemsList: [RecentItemModel] = []
    
    init(){
        decodeLocalRecentItems()
    }
    
    func decodeLocalRecentItems(){
        guard
            let data = UserDefaults.standard.data(forKey: "recentItems"),
            let decodedRecentItems = try? JSONDecoder().decode([RecentItemModel].self, from: data)
        else {
            return
        }
        
        self.recentItemsList = decodedRecentItems
    }
    
    func encodeLocalRecentItems(){
        if let encoded = try? JSONEncoder().encode(recentItemsList){
            UserDefaults.standard.setValue(encoded, forKey: "recentItems")
        }
    }
    
    public func countRecentItems() -> Int {
        return recentItemsList.count
    }
    
    public func clearRecentItems() {
        recentItemsList.removeAll()
        
        encodeLocalRecentItems()
    }
    
    public func addRecentItem(id: String, date: Date) {
        if let index = self.recentItemsList.lastIndex(where: {$0.id == id}) {
            self.recentItemsList[index].opened = date
        }else{
            recentItemsList.append(RecentItemModel(id: id, opened: date))
        }
        
        recentItemsList = recentItemsList.sorted(by: {$0.opened > $1.opened})
        encodeLocalRecentItems()
    }
}
