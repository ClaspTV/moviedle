//
//  ConnectedView.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI

struct ConnectedView: View {
    @Binding var activeRoute: Route?
    @Binding var showGameViewFromRoute: Route?
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
                Text(StaticText.successfullyConnected)
                    .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.primaryColor)
                    .padding(.horizontal, 40)
                    .padding(.bottom,-20)
                Text(viewModel.deviceName)
                    .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Constants.primaryColor)
                    .padding(.horizontal, 40)
                    .padding()
                
                VStack(alignment: .leading, spacing: 5) {
                    StyledTextField(text: $viewModel.currentUsername, placeholder: StaticText.enterUsername)
                        .padding(.horizontal, 80)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.custom(Constants.fontFamily, size: Constants.tertiaryFontSize))
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .padding(.top,-20)
                }
                
                // Buttons
                HStack(spacing: 10) {
                    Button(action: {
                        viewModel.createGame()
                        activeRoute = .StartGameView
                    }) {
                        Text(StaticText.createGame)
                            .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                            .foregroundColor(Constants.secondaryColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Constants.primaryColor)
                            .cornerRadius(30)
                            .padding(.trailing, 5)
                    }.buttonStyle(PressableButtonStyle())
                    
                    Button(action: {
                        activeRoute = .JoinGameView
                        viewModel.updateUserName()
                    }) {
                        Text(StaticText.joinGame)
                            .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                            .foregroundColor(Constants.secondaryColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Constants.primaryColor)
                            .cornerRadius(30)
                            .padding(.leading, 5)
                    }
                    .buttonStyle(PressableButtonStyle())
                }
                .padding()
                .disabled(!viewModel.isButtonEnabled())
                .opacity(viewModel.isButtonEnabled() ? 1.0 : 0.5)
            }
        }
        .onAppear(){
            if(showGameViewFromRoute == nil ){
                viewModel.reset()
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .navigationBarHidden(true)
        .overlay(
            Button(action: {
                activeRoute = .TVDisconnectView
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
        ConnectedView(
            activeRoute: .constant(nil),
            showGameViewFromRoute: .constant(nil),
            viewModel: ConnectedViewModel()
        )
    }
}
