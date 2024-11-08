//
//  AvatarGenerator.swift
//  Movidle
//
//  Created by Sidharth Datta on 08/11/24.
//

import Foundation

/// A utility class for managing and generating random avatar URLs
class AvatarGenerator {
    
    // MARK: - Properties
    
    /// Collection of avatar URLs from various services (PNG only)
    static let avatarUrls: [String] = [
        // RoboHash Avatars (PNG)
        "https://robohash.org/robot1.png",
        "https://robohash.org/robot2.png",
        "https://robohash.org/robot3.png",
        "https://robohash.org/robot4.png",
        "https://robohash.org/robot5.png",
        
        // UI Avatars (PNG)
        "https://ui-avatars.com/api/?name=John+Doe&background=random&format=png",
        "https://ui-avatars.com/api/?name=Jane+Smith&background=random&format=png",
        "https://ui-avatars.com/api/?name=Alex+Brown&background=random&format=png",
        
        // Pravatar (Already PNG)
        "https://i.pravatar.cc/150?img=1",
        "https://i.pravatar.cc/150?img=2",
        "https://i.pravatar.cc/150?img=3",
        "https://i.pravatar.cc/150?img=4",
        "https://i.pravatar.cc/150?img=5",
        "https://i.pravatar.cc/150?img=6",
        "https://i.pravatar.cc/150?img=7",
        "https://i.pravatar.cc/150?img=8"
    ]
    
    // MARK: - Public Methods
    
    /// Returns a random avatar URL from the predefined collection
    /// - Returns: A random avatar URL string
    static func getRandomAvatar() -> String {
        guard !avatarUrls.isEmpty else { return generateRandomAvatar() }
        return avatarUrls.randomElement() ?? generateRandomAvatar()
    }
    
    /// Generates a completely random avatar URL using various services
    /// - Returns: A generated avatar URL string
    static func generateRandomAvatar() -> String {
        let services = AvatarService.allCases
        guard let randomService = services.randomElement() else {
            return "https://ui-avatars.com/api/?name=Default&background=random&format=png"
        }
        
        return generateAvatar(using: randomService)
    }
    
    /// Assigns random avatars to an array of users
    /// - Parameters:
    ///   - users: Array of users to assign avatars to
    ///   - useGenerated: Whether to use generated URLs instead of preset ones
    /// - Returns: Array of users with assigned avatars
    static func assignRandomAvatars<T>(to users: [T],
                                     keyPath: WritableKeyPath<T, String>,
                                     useGenerated: Bool = false) -> [T] {
        users.map { user in
            var mutableUser = user
            mutableUser[keyPath: keyPath] = useGenerated ? generateRandomAvatar() : getRandomAvatar()
            return mutableUser
        }
    }
    
    // MARK: - Private Methods
    
    private static func generateAvatar(using service: AvatarService) -> String {
        switch service {
        case .robohash:
            let randomText = UUID().uuidString
            return "https://robohash.org/\(randomText).png"
            
        case .uiAvatars:
            let names = ["John", "Jane", "Alex", "Sam", "Pat"]
            let randomName = names.randomElement() ?? "User"
            return "https://ui-avatars.com/api/?name=\(randomName)&background=random&format=png"
            
        case .pravatar:
            let randomId = Int.random(in: 1...70)
            return "https://i.pravatar.cc/150?img=\(randomId)"
        }
    }
}

// MARK: - Supporting Types

/// Available avatar services for generation (PNG only)
private enum AvatarService: CaseIterable {
    case robohash
    case uiAvatars
    case pravatar
}
