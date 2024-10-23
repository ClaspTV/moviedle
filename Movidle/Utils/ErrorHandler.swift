//
//  ErrorHandler.swift
//  Movidle
//
//  Created by Sidharth Datta on 22/10/24.
//

import Foundation

// Main error enum
enum GameError: LocalizedError {
    case network(NetworkError)
    case game(GameplayError)
    case server(ServerError)
    case system(SystemError)
    
    // Network related errors
    enum NetworkError {
        case invalidURL
        case connectionFailed
        case timeout
        case noInternetConnection
    }
    
    // Gameplay related errors
    enum GameplayError {
        case noMoviesAvailable
        case invalidGameState
        case playerDisconnected
        case tvDisconnected
        case invalidClipData
    }
    
    // Server related errors
    enum ServerError {
        case invalidResponse
        case decodingFailed
        case serverError(Int)
        case invalidData
    }
    
    // System related errors
    enum SystemError {
        case messageFailure(String)
        case unknown(String)
    }
    
    // Provide localized description for each error
    var errorDescription: String? {
        switch self {
        case .network(let error):
            switch error {
            case .invalidURL:
                return "Invalid URL provided"
            case .connectionFailed:
                return "Failed to connect to server"
            case .timeout:
                return "Request timed out"
            case .noInternetConnection:
                return "No internet connection"
            }
            
        case .game(let error):
            switch error {
            case .noMoviesAvailable:
                return "No movies available"
            case .invalidGameState:
                return "Invalid game state"
            case .playerDisconnected:
                return "Player disconnected"
            case .tvDisconnected:
                return "TV disconnected"
            case .invalidClipData:
                return "Invalid clip data"
            }
            
        case .server(let error):
            switch error {
            case .invalidResponse:
                return "Invalid response from server"
            case .decodingFailed:
                return "Failed to process server response"
            case .serverError(let code):
                return "Server error: \(code)"
            case .invalidData:
                return "Invalid data received from server"
            }
            
        case .system(let error):
            switch error {
            case .messageFailure(let message):
                return "System error: \(message)"
            case .unknown(let message):
                return "Unknown error: \(message)"
            }
        }
    }
}

// Error handling utility
struct ErrorHandler {
    static func handle(_ error: Error) -> GameError {
        switch error {
        case let gameError as GameError:
            return gameError
            
        case let decodingError as DecodingError:
            return .server(.decodingFailed)
            
        case let urlError as URLError:
            switch urlError.code {
            case .notConnectedToInternet:
                return .network(.noInternetConnection)
            case .timedOut:
                return .network(.timeout)
            default:
                return .network(.connectionFailed)
            }
            
        default:
            return .system(.unknown(error.localizedDescription))
        }
    }
}
