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
        case crime
        case lawextract
    }
    
    init(){
        
    }

    func downloadJsonData(_ type: DataType) async -> Array<Any>?{
        //http://rjweb.cz/data/testingkitt/offenses.json
        
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            fatalError("Configuration file missing baseUrl variable")
        }
        
        switch(type){
            case .offense:
                guard let offenseFile = Bundle.main.object(forInfoDictionaryKey: "OFFENSE_JSON_FILE") else{
                    fatalError("OFFENSE - Configuration file missing variable")
                }
            
                guard let url = URL(string: "\(baseUrl)\(offenseFile)") else{
                    print("Invalid URL")
                    return []
                }

                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let decodedResponse = try? JSONDecoder().decode([OffenseModel].self, from: data){
                        return decodedResponse
                    }else{
                        fatalError("OFFENSE - Json could not be decoded")
                    }
                }catch{
                    fatalError("OFFENSE - Data failed to be recieved")
                }
            case .crime:
                guard let crimeFile = Bundle.main.object(forInfoDictionaryKey: "CRIME_JSON_FILE") else{
                    fatalError("CRIME - Configuration file missing variable")
                }
            
                guard let url = URL(string: "\(baseUrl)\(crimeFile)") else{
                    print("Invalid URL")
                    return []
                }

                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let decodedResponse = try? JSONDecoder().decode([CrimeModel].self, from: data){
                        return decodedResponse
                    }else{
                        fatalError("CRIME - Json could not be decoded")
                    }
                }catch{
                    fatalError("CRIME - Data failed to be recieved")
                }
            case .lawextract:
                guard let leFile = Bundle.main.object(forInfoDictionaryKey: "LAWEXTRACT_JSON_FILE") else{
                    fatalError("LAWEXTRACT - Configuration file missing variable")
                }
            
                guard let url = URL(string: "\(baseUrl)\(leFile)") else{
                    print("Invalid URL")
                    return []
                }

                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let decodedResponse = try? JSONDecoder().decode([LawExtractModel].self, from: data){
                        return decodedResponse
                    }else{
                        fatalError("LAWEXTRACT - Json could not be decoded")
                    }
                }catch{
                    fatalError("LAWEXTRACT - Data failed to be recieved")
                }
        }
        
        
        return []
    }
}


