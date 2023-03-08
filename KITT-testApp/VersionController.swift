//
//  VersionController.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//

import Foundation

class VersionController {
    @Published var newestVersion: String = "0.0.0"
    init(){
        
    }
    
    static let versionController = VersionController()
    
    func getNewestVersion() async -> String {
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            fatalError("Configuration file missing baseUrl variable")
        }
        
        guard let versionFile = Bundle.main.object(forInfoDictionaryKey: "VERSION_FILE") else{
            fatalError("VERSION - Configuration file missing variable")
        }
    
        guard let url = URL(string: "\(baseUrl)\(versionFile)") else{
            print("Invalid URL")
            return ""
        }
        
        let data = try! Data(contentsOf: url)
        let version = String(data: data, encoding: .utf8)!
        
        self.newestVersion = version
        return version
    }
    
    func loadVersionUpdates() async -> [VersionModel]? {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            fatalError("Configuration file missing baseUrl variable")
        }
        
        guard let versionFile = Bundle.main.object(forInfoDictionaryKey: "VERSION_JSON_FILE") else{
            fatalError("OFFENSE - Configuration file missing variable")
        }
    
        guard let url = URL(string: "\(baseUrl)\(versionFile)") else{
            print("Invalid URL")
            return []
        }

        do {
            let (data, _) = try await URLSession(configuration: config).data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([VersionModel].self, from: data){
                return decodedResponse
            }else{
                fatalError("VERSION - Json could not be decoded")
            }
        }catch{
            fatalError("VERSION - Data failed to be recieved")
        }
    }
}
