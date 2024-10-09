//
//  TVConnectionViewModel.swift
//  Movidle
//
//  Created by Sidharth Datta on 09/10/24.
//

import SwiftUI
import Combine

class TVConnectionViewModel: ObservableObject {
    @Published var username = ""
    @Published var usernameValidationMessage = ""
    @Published var isUsernameFocused = false
    @Published var hasSavedUsername = false
    @Published var isEditing = false
    @Published var connectionState: ConnectionStateProgress = .notConnected

    private var cancellables = Set<AnyCancellable>()
    private let storage = UserDefaultsStorage()
    
    init() {
        loadSavedUsername()
        
        $username
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { self.validateUsername($0) }
            .assign(to: \.usernameValidationMessage, on: self)
            .store(in: &cancellables)
    }
    
    private func loadSavedUsername() {
        if let savedUsername = storage.getUsername() {
            username = savedUsername
            usernameValidationMessage = validateUsername(savedUsername)
            hasSavedUsername = true
            isEditing = false
        } else {
            hasSavedUsername = false
            isEditing = true
        }
    }
    
    func validateUsername(_ username: String) -> String {
        let usernameRegex = "^[a-zA-Z0-9_]{3,15}$"
        if username.isEmpty {
            return ""
        } else if username.range(of: usernameRegex, options: .regularExpression) != nil {
            return "Username is valid"
        } else {
            return "Username must be 3-15 characters long and can only contain letters, numbers, and underscores"
        }
    }
    
    var isUsernameValid: Bool {
        usernameValidationMessage == "Username is valid"
    }
    
    func connectToTV() {
        if isUsernameValid {
            print("Connect to TV with username: \(username)")
            storage.saveUsername(username)
            hasSavedUsername = true
            isEditing = false
            // Implement your connection logic here
            simulateConnection()
        }
    }
    
    func simulateConnection() {
           connectionState = .searching
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
               self?.connectionState = .connecting
               DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                   self?.connectionState = .connected
               }
           }
       }
    
    func startEditing() {
        isEditing = true
    }
    
    func dismissKeyboard() {
        if isUsernameFocused {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
