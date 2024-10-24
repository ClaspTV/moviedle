//
//  JoinGameViewModel.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI
import Combine

class JoinGameViewModel: ObservableObject {
    
    @Published var currentUsername: String = VizbeeXWrapper.shared.getUserName()
    @Published var joinCode: String = ""
    @Published var isJoinButtonEnabled: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupPublishers()
        print("username: ", currentUsername)
    }
    
    private func setupPublishers() {
        Publishers.CombineLatest($currentUsername, $joinCode)
            .map { userName, joinCode in
                return !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                       !joinCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            .assign(to: \.isJoinButtonEnabled, on: self)
            .store(in: &cancellables)
    }
    
    func createMessageParams() -> [String: Any] {
        return [
            "msgType": MessageType.joinGame.rawValue,
            "joinCode": "movidle-" + joinCode
        ]
    }
    
    func joinGame() {
        //TODO: Handle wrong join code
        VizbeeXWrapper.shared.connectBroadcast(namespace: "movidle-" + joinCode) { success, error in
            if(success) {
                VizbeeXWrapper.shared.send(message:self.createMessageParams(), on: .unicast) { success, error in
                    if(!success) {
                        //TODO: Handle failure
                    }
                }
            }else{
                //TODO: Handle failure
            }
        }
    }
}
