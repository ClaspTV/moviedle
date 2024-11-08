//
//  JoinGameView.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI

struct JoinGameView: View {
    @Binding var activeRoute: Route?
    @Binding var showGameViewFromRoute: Route?
    @ObservedObject var viewModel: JoinGameViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isKeyboardVisible = false
    
    var body: some View {
        ZStack {
            // Background
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {
                    // Add some top padding to ensure content isn't hidden behind the back button
                    Spacer()
                        .frame(height: 60)
                    
                    Image(.film)
                        .foregroundColor(Constants.primaryColor)
                    
                    Text(StaticText.enterJoinCode)
                        .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                        .padding(.bottom, 40)
                    
                    StyledTextField(text: $viewModel.joinCode, placeholder: StaticText.joinCode)
                        .padding(.horizontal, 80)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                    }
                    
                    Button(action: {
                        showGameViewFromRoute = .JoinGameView
                        activeRoute = nil
                        viewModel.joinGame()
                    }) {
                        Text(StaticText.join)
                            .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                            .foregroundColor(Constants.secondaryColor)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Constants.primaryColor)
                            .cornerRadius(30)
                            .padding(.horizontal, 40)
                    }
                    .buttonStyle(PressableButtonStyle())
                    .padding(.horizontal, 40)
                    .disabled(!viewModel.isJoinButtonEnabled)
                    .opacity(viewModel.isJoinButtonEnabled ? 1.0 : 0.5)
                    
                    // Add bottom padding when keyboard is visible
                    if isKeyboardVisible {
                        Spacer()
                            .frame(height: 100) // Adjust this value based on your needs
                    }
                }
                .frame(minHeight: UIScreen.main.bounds.height - 100) // Ensure the content takes up most of the screen
            }
        }
        .navigationBarHidden(true)
        .overlay(
            CustomBackButton(action: {
                presentationMode.wrappedValue.dismiss()
                activeRoute = nil
            })
            .padding(.leading, 16)
            .padding(.top, 8),
            alignment: .topLeading
        )
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                         to: nil,
                                         from: nil,
                                         for: nil)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            isKeyboardVisible = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardVisible = false
        }
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView(
            activeRoute: .constant(.JoinGameView),
            showGameViewFromRoute: .constant(nil),
            viewModel: JoinGameViewModel()
        )
    }
}
