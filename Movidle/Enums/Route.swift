//
//  Screens.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import Foundation

enum Route: Identifiable {
    case TVSelectionView
    case TVDisconnectView
    case JoinGameView
    case StartGameView
    
    var id: Self { self }
}
