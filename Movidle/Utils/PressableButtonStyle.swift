//
//  PressableButtonStyle.swift
//  Movidle
//
//  Created by Sidharth Datta on 16/10/24.
//

import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // Slight scale effect
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
