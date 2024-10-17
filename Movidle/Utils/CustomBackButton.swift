//
//  CustomBackButton.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI

struct CustomBackButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .foregroundColor(Constants.primaryColor)
                .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
        }
    }
}
