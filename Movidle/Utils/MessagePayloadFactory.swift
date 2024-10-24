//
//  MessagePayloadFactory.swift
//  Movidle
//
//  Created by Sidharth Datta on 22/10/24.
//

import Foundation

// Updated API Response Models
struct ApiResponse: Codable {
    let data: [Movie]
    
    // Convenience method to create from dictionary
    init?(_ dictionary: [String: Any]) {
        guard let data = dictionary["data"] as? [[String: Any]] else {
            return nil
        }
        
        let movies = data.compactMap { Movie(dictionary: $0) }
        self.data = movies
    }

    func toDictionary() -> [String: Any] {
        return [
            "data": data.map { $0.toDictionary() }
        ]
    }
}

// Existing Clip and Movie structs remain the same
struct Clip: Codable {
    let id: String
    let score: String
    let url: String
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let score = dictionary["score"] as? String,
              let url = dictionary["url"] as? String else {
            return nil
        }
        
        self.id = id
        self.score = score
        self.url = url
    }
    
    func toDictionary() -> [String: String] {
        return [
            "id": id,
            "score": score,
            "url": url
        ]
    }
}

struct Movie: Codable {
    let name: String
    let id: String
    let clips: [Clip]
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let id = dictionary["id"] as? String,
              let clipsArray = dictionary["clips"] as? [[String: Any]] else {
            return nil
        }
        
        self.name = name
        self.id = id
        self.clips = clipsArray.compactMap { Clip(dictionary: $0) }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "id": id,
            "clips": clips.map { $0.toDictionary() }
        ]
    }
}

// Updated message type enum
enum MessageType: String, Codable {
    case startGame = "start_game"
    case scoreUpdate = "score_update"
    case gameStatus = "game_status"
    case joinGame = "join_game"
}

// Game status enum
enum GameStatusType: String, Codable {
    case clipStarted = "clip_started"
    case clipEnded = "clip_ended"
    case movieCompleted = "movie_completed"
}

// New GameStatusPayload
struct GameStatusPayload: Codable {
    let msgType: MessageType
    let status: GameStatusType
    let movieName: String
    let clipId: String
    let movieNumber: Int
    let totalMovies: Int
    let clipNumber: Int
    let totalClips: Int
    let clipScore: Int
    
    init?(dictionary: [String: Any]) {
        guard let msgTypeString = dictionary["msgType"] as? String,
              let msgType = MessageType(rawValue: msgTypeString),
              msgType == .gameStatus,
              let statusString = dictionary["status"] as? String,
              let status = GameStatusType(rawValue: statusString),
              let movieName = dictionary["movieName"] as? String else {
              return nil
        }
        
        self.msgType = msgType
        self.status = status
        self.movieName = movieName
        self.clipId = dictionary["clipId"] as? String ?? ""
        self.movieNumber = dictionary["movieNumber"] as? Int ?? 1
        self.totalMovies = dictionary["totalMovies"] as? Int ?? 1
        self.clipNumber = dictionary["clipNumber"] as? Int ?? 1
        self.totalClips = dictionary["totalClips"] as? Int ?? 1
        
        // Handle clipScore which might come as String or Int
        if let scoreString = dictionary["clipScore"] as? String {
            self.clipScore = Int(scoreString) ?? 0
        } else if let scoreInt = dictionary["clipScore"] as? Int {
            self.clipScore = scoreInt
        } else {
            self.clipScore = 0
        }
    }
    
    // Convert to dictionary
    func toDictionary() -> [String: Any] {
        return [
            "msgType": msgType.rawValue,
            "status": status.rawValue,
            "movieName": movieName,
            "clipId": clipId,
            "clipScore": clipScore
        ]
    }
}

// Existing StartGamePayload and ScoreUpdatePayload remain the same
struct StartGamePayload: Codable {
    let msgType: MessageType
    let movies: [Movie]
    
    init?(dictionary: [String: Any]) {
        guard let msgTypeString = dictionary["msgType"] as? String,
              let msgType = MessageType(rawValue: msgTypeString),
              msgType == .startGame,
              let moviesArray = dictionary["movies"] as? [[String: Any]] else {
            return nil
        }
        
        self.msgType = msgType
        self.movies = moviesArray.compactMap { Movie(dictionary: $0) }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "msgType": msgType.rawValue,
            "movies": movies.map { movie in
                [
                    "name": movie.name,
                    "id": movie.id,
                    "clips": movie.clips.map { clip in
                        [
                            "id": clip.id,
                            "score": clip.score,
                            "url": clip.url
                        ]
                    }
                ]
            }
        ]
    }
}

struct ScoreUpdatePayload: Codable {
    let msgType: MessageType
    let userId: String
    let userName: String
    let score: String
    
    init?(dictionary: [String: Any]) {
        guard let msgTypeString = dictionary["msgType"] as? String,
              let msgType = MessageType(rawValue: msgTypeString),
              msgType == .scoreUpdate,
              let userId = dictionary["userId"] as? String,
              let userName = dictionary["userName"] as? String,
              let score = dictionary["score"] as? String else {
            return nil
        }
        
        self.msgType = msgType
        self.userId = userId
        self.userName = userName
        self.score = score
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "msgType": msgType.rawValue,
            "userId": userId,
            "userName": userName,
            "score": score
        ]
    }
}

// Updated factory to include game status payload
struct MessagePayloadFactory {
    static func createPayload(from dictionary: [String: Any]) -> (startGame: StartGamePayload?, scoreUpdate: ScoreUpdatePayload?, gameStatus: GameStatusPayload?) {
        guard let msgTypeString = dictionary["msgType"] as? String,
              let msgType = MessageType(rawValue: msgTypeString) else {
            return (nil, nil, nil)
        }
        
        switch msgType {
        case .startGame:
            return (StartGamePayload(dictionary: dictionary), nil, nil)
        case .scoreUpdate:
            return (nil, ScoreUpdatePayload(dictionary: dictionary), nil)
        case .gameStatus:
            return (nil, nil, GameStatusPayload(dictionary: dictionary))
        default:
            return (nil, nil, nil)
        }
    }
}
