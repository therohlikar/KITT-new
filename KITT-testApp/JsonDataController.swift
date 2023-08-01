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
    /**
     
     Asynchronous function that downloads file from url (LIST_JSON_FILES) and converts that file into Array of type FileModel, then loops through that array and in each FileModel downloads a file on given item's attribute name. Each downloaded file converts into Array of type ItemModel.
     
     - Returns: Array of type Any
     */
    func downloadJsonData() async -> Array<Any>?{
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            fatalError("Configuration file missing baseUrl variable")
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        //DOWNLOAD LIST OF .JSON FILES

        guard let listFile = Bundle.main.object(forInfoDictionaryKey: "LIST_JSON_FILES") else{
            fatalError("LIST.TXT - Configuration file missing variable")
        }
    
        guard let url = URL(string: "\(baseUrl)\(listFile)") else{
            print("Invalid URL")
            return []
        }
        
        do {
            let (data, _) = try await URLSession(configuration: config).data(from: url)
            if let files = try? JSONDecoder().decode([FileModel].self, from: data){
                var items: [ItemModel] = []
                
                for file in files {
                    guard let url = URL(string: "\(baseUrl)\(file.name)\(file.format)") else{
                        print("Invalid URL")
                        return []
                    }

                    do {
                        let (data, _) = try await URLSession(configuration: config).data(from: url)
                        if let decodedResponse = try? JSONDecoder().decode([ItemModel].self, from: data){
                            items.append(contentsOf: decodedResponse)
                        }else{
                            fatalError("CONTENTITEM - Json could not be decoded")
                        }
                    }catch{
                        fatalError("CONTENTITEM - Data failed to be recieved")
                    }
                }
                
                return items
            }else{
                fatalError("LIST.TXT - Json could not be decoded")
            }
        }catch{
            fatalError("LIST.TXT - Data failed to be recieved")
        }
        return []
    }
    
    static let controller = JsonDataController()
    
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
