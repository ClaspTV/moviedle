//
//  MainViewModel.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI
import Combine
import VizbeeKit

class MainViewModel: ObservableObject {
    @Published var vizbeeSessionState: VZBSessionState = VZBSessionState.noDeviceAvailable
    @Published var showGameViewFromRoute: Route? = nil
    
    private var stateChangeObserver: NSObjectProtocol?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(notification), name: Notification.Name(VizbeeWrapper.kVZBCastStateChanged), object: nil)
    }
    
    @objc func notification(notification: Notification){
        if let state = notification.userInfo?[VizbeeWrapper.kVZBCastState] as? VZBSessionState {
            switch state {
            case .connected:
                self.vizbeeSessionState = state
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    VizbeeXWrapper.shared.connect(completion: nil)
                }
                
            case .notConnected:
                self.vizbeeSessionState = state
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    VizbeeXWrapper.shared.disconnect()
                }
                self.showGameViewFromRoute = nil
            default:
                break
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
