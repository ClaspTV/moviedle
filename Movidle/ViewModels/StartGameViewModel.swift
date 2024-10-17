//
//  StartGameViewModel.swift
//  Movidle
//
//  Created by Sidharth Datta on 14/10/24.
//

import SwiftUI

class StartGameViewModel: ObservableObject {
    @Published var userName: String = ""
    let gameCode: String
    @Published var isSharePresented = false
    
    init(gameCode: String = "MOVIE123") {
        self.gameCode = gameCode
    }
    
    func shareGameCode() {
        isSharePresented = true
    }
    
    func startGame() {
        // Implement game start logic here
        print("Starting game with username: \(userName)")
        // You might want to navigate to the next screen or initialize the game here
    }
    
    func isStartGameButtonEnabled() -> Bool {
        return !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
