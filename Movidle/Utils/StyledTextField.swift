//
//  StyledTextField.swift
//  Movidle
//
//  Created by Sidharth Datta on 14/10/24.
//

import SwiftUI

struct StyledTextField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Constants.primaryColor.opacity(0.8))
                    .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    
            }
            
            TextField("", text: $text)
                .foregroundColor(Constants.primaryColor)
                .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                .multilineTextAlignment(.center)
                .frame(minWidth: 0, maxWidth: .infinity)
        }
        .frame(height: 50,alignment: .center)
        .background(Constants.primaryColor.opacity(0.2))
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.clear, lineWidth: 2)
        )
    }
}
