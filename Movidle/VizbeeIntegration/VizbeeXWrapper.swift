//
//  VizbeeXWrapper.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import Foundation
import VizbeeKit
import VizbeeXMessageKit

protocol VizbeeXWrapperDelegate: AnyObject {
    func didReceiveMessage(_ message: VZBXMessage, on connectionType: VZBXMessageConnectionType)
    func didReceiveEvent(_ connectionType: VZBXMessageConnectionType, event: VZBXMessageConnectionEvent, eventInfo: VZBXMessageConnectionEventInfo)
}

class VizbeeXWrapper {
    static let shared = VizbeeXWrapper()
    
    private var unicastX: VizbeeX?
    private var broadcastX: VizbeeX?
    
    weak var delegate: VizbeeXWrapperDelegate?
    
    private let MESSAGE_NAMESPACE = "tv.vizbee.movidle"
    private(set) var currentChannelId: String = ""
    
    private var userName: String = ""
    
    private init() {}
    
    func getChannelId() -> String {
        return self.currentChannelId
    }
    
    func setUserName(_ userName:String){
        self.userName = userName
    }
    
    func getUserName() -> String {
        return self.userName
    }
    
    func getUserID() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
    
    func connect(completion: ((Bool, String?) -> Void)?) {
        
        var errorMessage: String?
        
        connectUnicast { success, error in
            if(success){
                if((completion) != nil){
                    completion?(success, errorMessage)
                }
            }
            if let error = error {
                errorMessage = "Unicast: \(error)"
            }
        }
    }
    
    private func connectUnicast(completion: @escaping (Bool, String?) -> Void) {
        unicastX = VizbeeX()
        unicastX?.connect(connectionType: .unicast, namespace: MESSAGE_NAMESPACE) { [weak self] event, eventInfo in
            self?.handleEvent(.unicast, event: event, eventInfo: eventInfo)
        }
        unicastX?.receive { [weak self] message in
            print("Received message: \(message.payload)")
            self?.delegate?.didReceiveMessage(message, on: .unicast)
        }
        // Assuming connect is asynchronous and has a completion handler
        // If it doesn't, you might need to adjust this part
        completion(true, nil)
    }
    
    func connectBroadcast(namespace: String ,completion: @escaping (Bool, String?) -> Void) {
        if(currentChannelId == ""){
            currentChannelId = namespace
        }
        
        broadcastX = VizbeeX()
        broadcastX?.connect(connectionType: .broadcast, namespace: namespace) { [weak self] event, eventInfo in
            self?.handleEvent(.broadcast, event: event, eventInfo: eventInfo)
        }
        broadcastX?.receive { [weak self] message in
            self?.delegate?.didReceiveMessage(message, on: .broadcast)
        }
        // Assuming connect is asynchronous and has a completion handler
        // If it doesn't, you might need to adjust this part
        completion(true, nil)
    }
    
    func send(message: [String: Any], on connectionType: VZBXMessageConnectionType, completion: @escaping (Bool, Any?) -> Void) {
        var message = message
        let vizbeeX: VizbeeX?
        switch connectionType {
        case .unicast:
            vizbeeX = unicastX
            message["channelId"] = currentChannelId
            message["userName"] = userName
            message["userId"] = getUserID()
            
        case .broadcast:
            vizbeeX = broadcastX
        default:
            completion(false, "Unsupported connection type")
            return
        }
        
        guard let vizbeeX = vizbeeX else {
            completion(false, "VizbeeX not initialized for \(connectionType)")
            return
        }
        
        let vzMessage = VZBXMessage.create(payload: message)
        
        print("Sending message: \(message)")
        vizbeeX.send(message: vzMessage) { success, info in
            completion(success, info)
        } onFailure: { error in
            completion(false, error.localizedDescription)
        }
    }
    
    func disconnect() {
        unicastX?.disconnect()
        broadcastX?.disconnect()
        unicastX = nil
        broadcastX = nil
        currentChannelId = ""
    }
    
    private func handleEvent(_ connectionType: VZBXMessageConnectionType, event: VZBXMessageConnectionEvent, eventInfo: VZBXMessageConnectionEventInfo) {
        delegate?.didReceiveEvent(connectionType, event: event, eventInfo: eventInfo)
    }
    
    func generateUniqueChannelId() {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"
        let allowedCharacters = letters + numbers
        
        let randomString = String((0..<4).map { _ in
            allowedCharacters.randomElement()!
        })
        
        currentChannelId = "movidle_\(randomString)"
    }
}


