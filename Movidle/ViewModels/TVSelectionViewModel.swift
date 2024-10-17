//
//  TVSelectionViewModel.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import Foundation
import Combine
import VizbeeKit
import VizbeeHomeOSKit

class TVSelectionViewModel: ObservableObject, HomeDiscoveryListener {
    @Published var devices: [HomeDevice] = []
    
    private var homeDiscovery: HomeDiscovery?
    
    init() {
        homeDiscovery = Vizbee.getHomeDiscovery()
        startDiscovery()
    }
    
    func startDiscovery() {
        homeDiscovery?.addHomeDiscoveryListener(listener: self)
    }
    
    func stopDiscovery() {
        homeDiscovery?.removeHomeDiscoveryListener(listener: self)
    }
    
    func onDeviceListUpdate(devices: [HomeDevice]) {
        DispatchQueue.main.async {
            self.devices = devices
        }
    }
    
    func selectDevice(_ device: HomeDevice) {
        let flowOptions = HomeFlowOptions(device: device)
        if let viewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController{
            Vizbee.getHomeFlows()?.startFlow(viewController: viewController,
                                             type: .cast,
                                             state: .selectDevice,
                                             options: flowOptions)
        }
    }
    
    func clickProxyCastIcon(){
        if let viewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController{
            Vizbee.getCastIconProxy().click(viewController)
        }
    }
    
    deinit {
        stopDiscovery()
    }
}


extension HomeDevice: Identifiable {
    public var id: String { return self.deviceId }  // Assuming deviceId is a unique identifier
}
