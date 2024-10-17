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
    
    private var stateChangeObserver: NSObjectProtocol?
    
    init() {
        stateChangeObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name(VizbeeWrapper.kVZBCastStateChanged),
            object: nil,
            queue: nil
        ) { [weak self] notification in
            if let state = notification.userInfo?[VizbeeWrapper.kVZBCastState] as? VZBSessionState {
                self?.vizbeeSessionState = state
            }
        }
    }
    
    deinit {
        if let stateChangeObserver = stateChangeObserver {
            NotificationCenter.default.removeObserver(stateChangeObserver)
        }
    }
}
