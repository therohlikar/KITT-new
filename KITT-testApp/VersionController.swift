//
//  VersionController.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//

import Foundation

class VersionController {
    static let controller = VersionController()
    
    /**
     
     */
  
    func getRemoteVersion() async -> String? {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            fatalError("Configuration file missing baseUrl variable")
        }
        
        guard let versionFile = Bundle.main.object(forInfoDictionaryKey: "VERSION_FILE") else{
            fatalError("VERSION - Configuration file missing variable")
        }
    
        guard let url = URL(string: "\(baseUrl)\(versionFile)") else{
            print("Invalid URL")
            return nil
        }
        
        if let data = await JsonDataController.controller.getDataFromUrlSession(url: url, config: config) {
            return String(decoding: data, as: UTF8.self)
        }
        
        return nil
    }
    
    /**
     
     */
    func getVersionNews(_ dc:DataController, saveLocally:Bool = true) async -> [VersionModel]? {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            fatalError("Configuration file missing baseUrl variable")
        }
        
        guard let versionFile = Bundle.main.object(forInfoDictionaryKey: "VERSION_JSON_FILE") else{
            fatalError("VERSION NEWS - Configuration file missing variable")
        }
    
        guard let url = URL(string: "\(baseUrl)\(versionFile)") else{
            print("Invalid URL")
            return []
        }
        
        if let data = await JsonDataController.controller.getDataFromUrlSession(url: url, config: config) {
            if let response:[VersionModel] = JsonDataController.controller.decodeData(data) {
                if saveLocally {
                    for item in response {
                        await dc.updateVersionNews(item)
                    }
                }
                return response
            }
        }
        
        return nil
    }
    /**
     
     */
    func isDataUpToDate() async -> Bool {
        if NetworkController.network.connected {
            if let currentVersion = UserDefaults.standard.string(forKey: "currentVersion") {
                if let remoteVersion = await self.getRemoteVersion() {
                    UserDefaults.standard.set(remoteVersion, forKey: "remoteVersion")
                    return currentVersion >= remoteVersion
                }
            }
        }
        return false
    }
    
    /**
     
     */
    func setCurrentVersionAsRemoteVersion() {
        if let currentVersion = UserDefaults.standard.string(forKey: "currentVersion") {
            if let remoteVersion = UserDefaults.standard.string(forKey: "remoteVersion") {
                UserDefaults.standard.set(remoteVersion, forKey: "currentVersion")
            }
        }
    }
}
