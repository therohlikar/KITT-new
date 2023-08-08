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

enum JsonException: Error {
    case wrongConfigurationKey
    case invalidUrl
    case networkConnectionLost
}

class JsonDataController{
    static let controller = JsonDataController()
    
    /**
     Asynchronously downloads remote content (main content) and saves it locally into database (context).
     
     If there is invalid url during converting the specific items, it won't throw an error but rather continues to the next one, so it won't fail the app altogether
     
     - Parameters:
        - dc: type DataController - context controller
        - saveLocally: Boolean determines if data are saved to the database or not
     - Returns: array of type ItemModel (converted json structures)
     - Throws:DataException.networkNotConnected if network is not connected, DataException.wrongConfigurationKey if any key is non existent, DataException.invalidUrl if final url is invalid
     */
    func getRemoteContent(_ dc:DataController, saveLocally:Bool = true) async throws -> [ItemModel] {
        if !NetworkController.network.connected {
            throw DataException.networkNotConnected
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            throw JsonException.wrongConfigurationKey
        }

        guard let listFile = Bundle.main.object(forInfoDictionaryKey: "LIST_JSON_FILES") else{
            throw JsonException.wrongConfigurationKey
        }
    
        guard let url = URL(string: "\(baseUrl)\(listFile)") else{
            throw JsonException.invalidUrl
        }
        
        var items:[ItemModel] = []
        
        if let data = try await JsonDataController.controller.getDataFromUrlSession(url: url, config: config) {
            if let response:[FileModel] = JsonDataController.controller.decodeData(data) {
                for item in response {
                    guard let itemUrl = URL(string: "\(baseUrl)\(item.name)\(item.format)") else{
                        continue
                    }
                    
                    if let itemData = try await JsonDataController.controller.getDataFromUrlSession(url: itemUrl, config: config) {
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
     Asynchronously gets data from url session as type Data
     - Returns: type Data or nil
     - Parameters:
        - url: type URL
        - config: type URLSessionConfiguration
     - Throws:DataException.networkNotConnected if network is not connected
     */
    func getDataFromUrlSession(url: URL, config: URLSessionConfiguration) async throws -> Data? {
        if !NetworkController.network.connected {
            throw DataException.networkNotConnected
        }
        
        do {
            let (data, _) = try await URLSession(configuration: config).data(from: url)
            return data
        }catch{
            print(error.localizedDescription)
        }
        
        return nil
    }

    /**
     Encodes data into json (string) and return its value
     - Returns: json structure encoded: String or empty string
     - Parameters:
        - object: T: Encodable (any object)
     */
    func encodeData<T: Encodable>(_ object: T) -> String {
        do {
            let data = try JSONEncoder().encode(object)
            return String(data: data, encoding: .utf8)!
        }catch{
            print(error.localizedDescription)
        }
        
        return ""
    }
    
    /**
     Decodes string into data and return its value
     - Returns: T: Decodable (any class) or nil
     - Parameters:
        - data: type Data
     */
    func decodeData<T: Decodable>(_ data: Data) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        }catch{
            print(error.localizedDescription)
        }
        
        return nil
    }
}
