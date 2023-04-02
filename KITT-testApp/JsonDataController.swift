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
        
        switch(type){
            case .contentitem:
                guard let ciFile = Bundle.main.object(forInfoDictionaryKey: "CONTENTITEM_JSON_FILE") else{
                    fatalError("CONTENTITEM - Configuration file missing variable")
                }
            
                guard let url = URL(string: "\(baseUrl)\(ciFile)") else{
                    print("Invalid URL")
                    return []
                }

                do {
                    let (data, _) = try await URLSession(configuration: config).data(from: url)
                    if let decodedResponse = try? JSONDecoder().decode([ItemModel].self, from: data){
                        return decodedResponse
                    }else{
                        fatalError("CONTENTITEM - Json could not be decoded")
                    }
                }catch{
                    fatalError("CONTENTITEM - Data failed to be recieved")
                }
        }
        
        
        return []
    }
}


