//
//  OutlinedText.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI

struct OutlinedText: UIViewRepresentable {
    let text: String
    let fontSize: CGFloat
    let fontFamily: String
    let strokeWidth: CGFloat
    let strokeColor: UIColor
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        let attributedString = NSAttributedString(string: text, attributes: [
            .strokeColor: strokeColor,
            .strokeWidth: -strokeWidth,
            .font: UIFont(name: fontFamily, size: fontSize)!,
            .foregroundColor: UIColor.clear
        ])
        
        uiView.attributedText = attributedString
    }
}
