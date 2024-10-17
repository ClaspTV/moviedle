//
//  TVDisconnectViewModel.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI
import Combine
import VizbeeKit

class TVDisconnectViewModel: ObservableObject {
    @Published var connectedDeviceName: String = VizbeeWrapper.shared.getConnectedTVInfo().friendlyName

    func disconnectFromTV() {
        VizbeeWrapper.shared.disconnectSession()
    }
}
