//
//  JsonDataController.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import Foundation

class JsonDataController{
    enum DataType{
        case contentitem
    }

    func downloadJsonData(_ type: DataType) async -> Array<Any>?{
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
}


