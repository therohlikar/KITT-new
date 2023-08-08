//
//  VersionController.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/8/23.
//

import Foundation

enum VersionException: Error {
    case wrongConfigurationKey
    case invalidUrl
    case networkConnectionLost
    case unableToGetRemoteVersion
}

class VersionController {
    static let controller = VersionController()
    
    /**
     Asynchronously gets version (String) from remote storage.
     
     Url is written in config files JSON_FILE_LINK and VERSION_FILE
     
     - Returns: Version (String) '0.0.0' or nil
     - Throws:VersionException.networkConnectionLost if network connection is lost, VersionException.wrongConfigurationKey if key is non existent, VersionException.invalidUrl if url has damaged string
     */
    func getRemoteVersion() async throws -> String? {
        if !NetworkController.network.connected {
            throw VersionException.networkConnectionLost
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            throw VersionException.wrongConfigurationKey
        }
        
        guard let versionFile = Bundle.main.object(forInfoDictionaryKey: "VERSION_FILE") else{
            throw VersionException.wrongConfigurationKey
        }
    
        guard let url = URL(string: "\(baseUrl)\(versionFile)") else{
            throw VersionException.invalidUrl
        }
        
        if let data = try await JsonDataController.controller.getDataFromUrlSession(url: url, config: config) {
            return String(decoding: data, as: UTF8.self)
        }
        
        return nil
    }
    
    /**
     Asynchronously gets news content from remote storage.
     
     Url is written in config files JSON_FILE_LINK and VERSION_JSON_FILE
     
     - Parameters:
        - dc: type of DataController, that is used to save content locally into context
        - saveLocally: determines if the content is supposed to be saved, default: true
     - Returns: Array of type VersionModel or nil
     - Throws:VersionException.networkConnectionLost if network connection is lost, VersionException.wrongConfigurationKey if key is non existent, VersionException.invalidUrl if url has damaged string
     */
    func getVersionNews(_ dc:DataController, saveLocally:Bool = true) async throws -> [VersionModel]? {
        if !NetworkController.network.connected {
            throw VersionException.networkConnectionLost
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "JSON_FILE_LINK") else {
            throw VersionException.wrongConfigurationKey
        }
        
        guard let versionFile = Bundle.main.object(forInfoDictionaryKey: "VERSION_JSON_FILE") else{
            throw VersionException.wrongConfigurationKey
        }
    
        guard let url = URL(string: "\(baseUrl)\(versionFile)") else{
            throw VersionException.invalidUrl
        }
        
        if let data = try await JsonDataController.controller.getDataFromUrlSession(url: url, config: config) {
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
     Asynchronously determines if local (current) version is up to date.
     
     Versions - remoteVersion and currentVersion - are stored in UserDefaults locally, remoteVersion is got via func getRemoteVersion()
     
     - Returns: Boolean if local (current) version is up to date
     - Throws:VersionException.networkConnectionLost if network connection is lost, VersionException.wrongConfigurationKey if key is non existent, VersionException.invalidUrl if url has damaged string
     */
    func isDataUpToDate() async throws -> Bool {
        if !NetworkController.network.connected {
            throw VersionException.networkConnectionLost
        }
        
        if let currentVersion = UserDefaults.standard.string(forKey: "currentVersion") {
            do {
                if let remoteVersion = try await self.getRemoteVersion() {
                    UserDefaults.standard.set(remoteVersion, forKey: "remoteVersion")
                    return currentVersion >= remoteVersion
                }
            }catch VersionException.wrongConfigurationKey{
                print("VersionException: Wrong configarion key used")
            }catch VersionException.invalidUrl{
                print("VersionException: Url is invalid")
            }catch{
                print("VersionException: \(error.localizedDescription)")
            }
        }
        return false
    }
    
    /**
     Asynchronously sets local (current) version to remote one.

     - Throws:VersionException.networkConnectionLost if network connection is lost, VersionException.wrongConfigurationKey if key is non existent, VersionException.invalidUrl if url has damaged string, VersionException.unableToGetRemoteVersion if nothing works and remote version is unknown
     */
    func setCurrentVersionAsRemoteVersion() async throws {
        var remoteVersion = ""
        if let storedRemoteVersion = UserDefaults.standard.string(forKey: "remoteVersion") {
            remoteVersion = storedRemoteVersion
        }else{
            do {
                if let downloadRemoteVersion = try await self.getRemoteVersion() {
                    remoteVersion = downloadRemoteVersion
                }
            }catch VersionException.wrongConfigurationKey{
                print("VersionException: Wrong configarion key used")
            }catch VersionException.invalidUrl{
                print("VersionException: Url is invalid")
            }catch{
                print("VersionException: \(error.localizedDescription)")
            }
        }
        
        if remoteVersion == "" {
            throw VersionException.unableToGetRemoteVersion
        }
        
        UserDefaults.standard.set(remoteVersion, forKey: "currentVersion")
    }
}
