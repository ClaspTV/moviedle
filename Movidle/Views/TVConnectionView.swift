//
//  TVConnectionView.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI
import VizbeeKit

struct TVConnectionView: View {
    @Binding var activeRoute: Route?
    @Binding var vizbeeSessionState: VZBSessionState
    
    var body: some View {
        ZStack {
            Image(.splash).resizable()
            
            VStack(spacing: 20) {
                Spacer()
                
                Text(StaticText.appName)
                    .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                    .foregroundColor(.white)
                
                Text(StaticText.introTitle)
                    .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                    .foregroundColor(Constants.primaryColor)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                Text(StaticText.introSubtitle)
                    .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                    .foregroundColor(Constants.primaryColor)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    activeRoute = .TVSelectionView
                }) {
                    Text(StaticText.connectBtn)
                        .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                        .foregroundColor(Constants.secondaryColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Constants.primaryColor)
                        .cornerRadius(50)
                        .padding(.horizontal, 40)
                }
                .buttonStyle(PressableButtonStyle())
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .animation(.easeOut, value: 0.25)
        }
        .onChange(of: vizbeeSessionState) { newValue in
            if(newValue == .connected) {
                activeRoute = nil
            }
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

// Preview
struct TVConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        TVConnectionView(activeRoute: .constant(nil),
                        vizbeeSessionState: .constant(.notConnected))
    }
}
