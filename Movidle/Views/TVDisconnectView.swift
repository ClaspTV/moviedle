//
//  TVDisconnectView.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI
import VizbeeKit

struct TVDisconnectView: View {
    @Binding var activeRoute: Route?
    @Binding var vizbeeSessionState: VZBSessionState
    @ObservedObject var viewModel: TVDisconnectViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
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
                
                Text(StaticText.connectedTo + viewModel.connectedDeviceName)
                    .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                    .foregroundColor(Constants.primaryColor)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 40)
                
                Button(action: {
                    viewModel.disconnectFromTV()
                    activeRoute = nil
                    }) {
                    Text(StaticText.disconnectBtn)
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
        }
        .navigationBarHidden(true)
        .overlay(
            CustomBackButton(action: {
                activeRoute = nil
            })
            .padding(.leading, 16)
            .padding(.top, 8),
            alignment: .topLeading
        )
    }
}

// Preview
struct TVDisconnectView_Previews: PreviewProvider {
    static var previews: some View {
        TVDisconnectView(
            activeRoute: .constant(.TVDisconnectView),
            vizbeeSessionState: .constant(.connected),
            viewModel: TVDisconnectViewModel()
        )
    }
}
