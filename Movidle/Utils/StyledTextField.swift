//
//  StyledTextField.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

struct StyledTextField: View {
    @Binding var text: String
    let placeholder: String
    let textLimit: Int?
    
    init(text: Binding<String>, placeholder: String, textLimit: Int? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.textLimit = textLimit
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Constants.primaryColor.opacity(0.8))
                    .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            }
            
            TextField("", text: $text)
            .limitInputLength(value: $text, length: textLimit ?? 100)
            .foregroundColor(Constants.primaryColor)
            .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
            .multilineTextAlignment(.center)
            .frame(minWidth: 0, maxWidth: .infinity)
            
            // Optional character count when limit is set
            if let limit = textLimit {
                Text("\(text.count)/\(limit)")
                    .font(.custom(Constants.fontFamily, size: Constants.tertiaryFontSize))
                    .foregroundColor(Constants.primaryColor.opacity(0.6))
                    .padding(.trailing, 12)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(height: 50, alignment: .center)
        .background(Constants.primaryColor.opacity(0.2))
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    VStack(spacing: 20) {
        StyledTextField(text: .constant(""), placeholder: "No limit")
    }
    .padding()
}
