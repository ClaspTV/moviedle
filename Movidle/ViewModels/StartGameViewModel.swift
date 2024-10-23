//
//  StartGameViewModel.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI

class StartGameViewModel: ObservableObject {
    
    @Published var currentUsername: String = VizbeeXWrapper.shared.getUserName()
    let gameCode: String
    @Published var isSharePresented = false
    
    init() {
        self.gameCode = VizbeeXWrapper.shared.currentChannelId.split(separator: "_").last.map { String($0) } ?? ""
        print("username: ", currentUsername)
    }
    
    func shareGameCode() {
        isSharePresented = true
    }
}
