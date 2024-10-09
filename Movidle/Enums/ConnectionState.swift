//
//  ConnectionState.swift
//  Movidle
//
//  Created by Sidharth Datta on 09/10/24.
//

import Foundation

enum ConnectionStateProgress: String {
       case notConnected = "Not Connected"
       case searching = "Searching for TVs..."
       case connecting = "Connecting to TV..."
       case connected = "Connected!"
}
