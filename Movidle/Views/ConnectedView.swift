//
//  ConnectedView.swift
//  Movidle
//
//  Created by Sidharth Datta on 10/10/24.
//

import SwiftUI

struct ConnectedView: View {
    @Binding var path: [Route]
    @ObservedObject var viewModel: ConnectedViewModel
    
    var body: some View {
        ZStack {
            // Background
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Film clapper icon
                Image(.film)
                    .foregroundColor(Constants.primaryColor)
                
                // Success message
                Text(StaticText.successfullyConnected + viewModel.deviceName)
                    .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.primaryColor)
                    .padding(.horizontal,40)
                
                // Buttons
                VStack(spacing: 10) {
                    Button(action: {
                        path.removeAll()
                        path.append(.StartGameView)
                    }) {
                        Text(StaticText.createGame)
                            .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                            .foregroundColor(Constants.secondaryColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Constants.primaryColor)
                            .cornerRadius(30)
                            .padding(.top,10)
                            .padding(.horizontal,40)
                    }.buttonStyle(PressableButtonStyle())
                    
                    Button(action:{
                        path.removeAll()
                        path.append(.JoinGameView)
                    }) {
                        Text(StaticText.joinGame)
                            .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                            .foregroundColor(Constants.secondaryColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Constants.primaryColor)
                            .cornerRadius(30)
                            .padding(.horizontal,40)
                    }
                    .buttonStyle(PressableButtonStyle())
                }
                .padding(.horizontal, 40)
            }
        }.navigationBarHidden(true)
            .overlay(
                Button(action: {
                    path.removeAll()
                    path.append(.TVDisconnectView)
                }) {
                    Text(StaticText.disconnect)
                        .foregroundColor(Constants.primaryColor)
                        .font(.custom(Constants.fontFamily, size: Constants.tertiaryFontSize))
                }
                .buttonStyle(PressableButtonStyle())
                .padding(.trailing, 30)
                .padding(.top, 16),
                alignment: .topTrailing
            )
    }
}

struct ConnectedView_Previews: PreviewProvider {
    
    static var previews: some View {
        ConnectedView(path: .constant([]),
                viewModel: ConnectedViewModel()
            )
    }
}
