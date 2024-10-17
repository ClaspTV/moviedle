//
//  JoinGameViewModel.swift
//  Movidle
//
//  Created by Sidharth Datta on 14/10/24.
//

import SwiftUI
import Combine

class JoinGameViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var joinCode: String = ""
    @Published var isJoinButtonEnabled: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupPublishers()
    }
    
    private func setupPublishers() {
        Publishers.CombineLatest($userName, $joinCode)
            .map { userName, joinCode in
                return !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                       !joinCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            .assign(to: \.isJoinButtonEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func joinGame() {
        // Here you would typically make an API call or perform some validation
        // For this example, we'll just simulate a join process
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            // Check if join code is valid (for example, must be 6 characters)
            if self.joinCode.count != 6 {
                self.errorMessage = "Invalid join code. Must be 6 characters."
                return
            }
            
            // If join is successful, you might want to navigate to the game screen
            // or update some app state
            print("Joined game successfully with username: \(self.userName) and code: \(self.joinCode)")
            // Here you would typically call a method to start the game or navigate to the game screen
        }
    }
}
