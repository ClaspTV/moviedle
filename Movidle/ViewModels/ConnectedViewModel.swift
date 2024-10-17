//
//  ConnectedViewModel.swift
//  Movidle
//
//  Created by Sidharth Datta on 10/10/24.
//

import SwiftUI
import Combine

class ConnectedViewModel: ObservableObject {
    @Published var deviceName: String = VizbeeWrapper.shared.getConnectedTVInfo().friendlyName
    
}
