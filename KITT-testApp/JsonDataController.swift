//
//  JsonDataController.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/3/23.
//

import Foundation

class JsonDataController{
    enum DataType{
        case offense
    }
    
    init(){
        
    }

    func downloadJsonData(_ type: DataType) async -> Array<Any>?{
        //http://rjweb.cz/data/testingkitt/test.json
        switch(type){
            case .offense:
                guard let url = URL(string: "http://rjweb.cz/data/testingkitt/test.json") else{
                    print("Invalid URL")
                    return []
                }

                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let decodedResponse = try? JSONDecoder().decode([OffenseModel].self, from: data){
                        return decodedResponse
                    }else{
                        print("something went wrong I guess")
                    }
                }catch{
                    print("Invalid data")
                }
        }
        
        
        return []
    }
}


