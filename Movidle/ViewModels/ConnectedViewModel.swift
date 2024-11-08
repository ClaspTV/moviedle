//
//  ConnectedViewModel.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI
import Combine

class ConnectedViewModel: ObservableObject {
    @Published var deviceName: String = VizbeeWrapper.shared.getConnectedTVInfo().friendlyName
    @Published var currentUsername: String = ""
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        currentUsername = VizbeeXWrapper.shared.getUserName()
        
        $currentUsername
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] name in
                self?.validateUserName(name)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func validateUserName(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            errorMessage = nil
        } else
        if trimmedName.count < 3 {
            errorMessage = "Username must be at least 3 characters long."
        }else if trimmedName.count >  15 {
            errorMessage = "Username must be at most 15 characters."
        } else if (trimmedName.range(of: "^[a-zA-Z0-9_]+$", options: .regularExpression, range: nil, locale: nil) == nil){
            errorMessage = "Username can only contain letters, numbers, and underscores."
        } else {
            errorMessage = nil
        }
    }
    
    func isButtonEnabled() -> Bool {
        return !currentUsername.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && errorMessage == nil
    }
    
    func createMessageParams() -> [String: Any]{
        let avatar = VizbeeXWrapper.shared.getUserAvatar()
        return [
          "msgType": MessageType.joinGame.rawValue,
          "userId": UIDevice.current.identifierForVendor!.uuidString,
          "userAvatar": avatar,
        ]
    }
    
    func updateUserName(){
        VizbeeXWrapper.shared.setUserName(currentUsername)
    }
    
    func createGame() {
        updateUserName()
        if VizbeeXWrapper.shared.getChannelId() == ""{
            VizbeeXWrapper.shared.generateUniqueChannelId()
            VizbeeXWrapper.shared.connectBroadcast(namespace: VizbeeXWrapper.shared.getChannelId()) { success, error in
                if(success){
                    VizbeeXWrapper.shared.send(message:self.createMessageParams(), on: .unicast) { success, error in
                        if(!success) {
                            //TODO: Handle failure
                        }
                    }
                    
                }else{
                    // Handle error
                }
            }
        }else{
            VizbeeXWrapper.shared.send(message:self.createMessageParams(), on: .unicast) { success, error in
                if(!success) {
                    //TODO: Handle failure
                }
            }
        }
    }
    
    func reset(){
        VizbeeXWrapper.shared.reset()
    }
}
