//
//  NetworkController.swift
//  KITT-testApp
//
//  Created by Radek Jeník on 3/10/23.
//

import Foundation
import Network
/**
 Class manages network connection status. The icon on the main page changes whenever change in network connection occurs. 
 */
class NetworkController: ObservableObject {
    static let network = NetworkController()
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue.global(qos: .background)

    @Published var connected: Bool = false
    private var isConnected: Bool = false

    init() {
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                OperationQueue.main.addOperation {
                    self.isConnected = true
                    self.connected = self.isConnected
                }
            } else {
                OperationQueue.main.addOperation {
                    self.isConnected = false
                    self.connected = self.isConnected
                }
            }
        }
    }
}
