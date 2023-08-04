//
//  JsonDataController.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import Foundation
/**
 Class manages JSON file downloads and its conversion into Array of type Any.
 */
class JsonDataController{
    static let controller = JsonDataController()
    
    /**
     
     */
    func getRemoteContent(_ dc:DataController, saveLocally:Bool = true) async -> [ItemModel] {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            fatalError("Configuration file missing baseUrl variable")
        }

        guard let listFile = Bundle.main.object(forInfoDictionaryKey: "LIST_JSON_FILES") else{
            fatalError("LIST.TXT - Configuration file missing variable")
        }
    
        guard let url = URL(string: "\(baseUrl)\(listFile)") else{
            fatalError("Invalid URL")
        }
        
        var items:[ItemModel] = []
        
        if let data = await JsonDataController.controller.getDataFromUrlSession(url: url, config: config) {
            if let response:[FileModel] = JsonDataController.controller.decodeData(data) {
                for item in response {
                    guard let itemUrl = URL(string: "\(baseUrl)\(item.name)\(item.format)") else{
                        print("Invalid URL")
                        continue
                    }
                    
                    if let itemData = await JsonDataController.controller.getDataFromUrlSession(url: itemUrl, config: config) {
                        if let itemResponse:[ItemModel] = JsonDataController.controller.decodeData(itemData) {
                            items.append(contentsOf: itemResponse)
                            
                            if saveLocally{
                                for item in items {
                                    await dc.updateItemContent(item)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return items
    }

    /**
     
     */
    func getDataFromUrlSession(url: URL, config: URLSessionConfiguration) async -> Data? {
        do {
            let (data, _) = try await URLSession(configuration: config).data(from: url)
            return data
        }catch{
            
        }
        
        return nil
    }

    /**
     
     */
    func encodeData<T: Encodable>(_ object: T) -> String {
        do {
            let data = try JSONEncoder().encode(object)
            return String(data: data, encoding: .utf8)!
        }catch{
            
        }
        
        return ""
    }
    
    /**
     
     */
    func decodeData<T: Decodable>(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        }catch{
            
        }
        
        return nil
    }
}
