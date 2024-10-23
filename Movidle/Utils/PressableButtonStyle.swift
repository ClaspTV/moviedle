//
//  PressableButtonStyle.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Slight scale effect
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
