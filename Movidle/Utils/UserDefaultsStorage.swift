//
//  UserDefaultsStorage.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import Foundation

class UserDefaultsStorage {
    private let defaults = UserDefaults.standard
    
    // MARK: - Keys
    private struct Keys {
        static let username = "com.movidle.username"
        // Add more keys here as needed
    }
    
    // MARK: - Username
    func saveUsername(_ username: String) {
        defaults.set(username, forKey: Keys.username)
    }
    
    func getUsername() -> String? {
        return defaults.string(forKey: Keys.username)
    }
    
    func removeUsername() {
        defaults.removeObject(forKey: Keys.username)
    }
    
    // MARK: - Generic methods
    func save<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getValue<T>(forKey key: String) -> T? {
        return defaults.object(forKey: key) as? T
    }
    
    func removeValue(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
    
    // MARK: - Clear all data
    func clearAllData() {
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
}
