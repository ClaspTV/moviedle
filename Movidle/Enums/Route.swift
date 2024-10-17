//
//  Screens.swift
//  Movidle
//
//  Created by Sidharth Datta on 10/10/24.
//

import Foundation

enum Route: Identifiable {
    case TVSelectionView
    case TVDisconnectView
    case JoinGameView
    case StartGameView
    
    var id: Self { self }
}
