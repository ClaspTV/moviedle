//
//  TVConnectingView.swift
//  Movidle
//
//  Created by Sidharth Datta on 09/10/24.
//

import SwiftUI

struct TVConnectingView: View {
    @ObservedObject var viewModel: TVConnectionViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.splash).resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Spacer()
                    
                    Text(Constants.appName)
                        .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                    Text(viewModel.connectionState.rawValue)
                        .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}
