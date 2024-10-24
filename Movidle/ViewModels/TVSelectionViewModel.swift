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

struct HomeDeviceModel: Identifiable {
    let id: String
    let deviceId: String
    let friendlyName: String
    
    init(from device: HomeDevice) {
        self.id = device.deviceId
        self.deviceId = device.deviceId
        self.friendlyName = device.friendlyName
    }
}

class TVSelectionViewModel: ObservableObject, HomeDiscoveryListener {
    @Published var homeDevices: [HomeDeviceModel] = []
    var devices : [HomeDevice] = []
    
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
            self.homeDevices = devices.map { HomeDeviceModel(from: $0) }
        }
    }
    
    func selectDevice(_ device: HomeDeviceModel) {
        let device = self.devices.first { $0.deviceId == device.deviceId }
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
