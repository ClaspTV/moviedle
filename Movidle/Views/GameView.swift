//
//  GameView.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import Foundation
import SwiftUI

enum GameState {
    case loading
    case waiting
    case playing
    case guessing
    case completed
}

struct GameView: View {
    @Binding var showGameViewFromRoute: Route?
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            // Background
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
               
                switch viewModel.gameState {
                case .loading:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                case .waiting:
                    // Film clapper icon
                    Image(.film)
                        .foregroundColor(Constants.primaryColor)
                        .padding()
                    Text(StaticText.appName)
                        .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                        .foregroundColor(Constants.primaryColor)
                        .padding()
                    Text(StaticText.waiting)
                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                    
                case .playing:
                    // Film clapper icon
                    Image(.film)
                        .foregroundColor(Constants.primaryColor)
                        .padding(.bottom, 40)
                    
                    Text(viewModel.movieTitle)
                        .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                        .padding()
                    Text(viewModel.movieSubtitle)
                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                        .padding(.bottom, 40)
                    Text(StaticText.playingOn + viewModel.connectedDeviceName)
                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                    
                case .guessing:
                    // Film clapper icon
                    Image(.film)
                        .foregroundColor(Constants.primaryColor)
                        .padding(.bottom, 40)
                    
                    Text(viewModel.movieTitle)
                        .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                        .padding()
                    Text(viewModel.movieSubtitle)
                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                        .padding(.bottom, 40)
                    Text("00:\(String(format: "%02d", viewModel.timeLeft))")
                        .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                        .foregroundColor(Constants.primaryColor)
                    Text(StaticText.timeLeft)
                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                        .padding(.bottom, 40)
                    
                    StyledTextField(text: $viewModel.userGuess, placeholder: StaticText.typeYourGuess)
                        .padding(.horizontal, 80)

                    Button(action: viewModel.submitGuess) {
                        Text(StaticText.submit)
                            .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                            .foregroundColor(Constants.secondaryColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.primaryColor)
                            .cornerRadius(30)
                            .padding(.horizontal, 40)
                    }
                    .buttonStyle(PressableButtonStyle())
                    .padding(.horizontal, 40)
                
                case .completed:
                    ScrollView {
                    // Film clapper icon
                    Image(.film)
                        .foregroundColor(Constants.primaryColor)
                   
                    Text("\(viewModel.movieTitle) Completed")
                        .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                    Text(StaticText.yourScore)
                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                        .foregroundColor(Constants.primaryColor)
                        Text("\($viewModel.userScore)")
                        .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                        .foregroundColor(Constants.primaryColor)
                        
                        VStack(spacing: 1) {
                            ForEach(viewModel.sortedPlayerScores.indices, id: \.self) { index in
                                HStack {
                                    Text("\(index + 1).   \(viewModel.sortedPlayerScores[index].name)")
                                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                                        .foregroundColor(Constants.secondaryColor)
                                    Spacer()
                                    Text("\(viewModel.sortedPlayerScores[index].score)")
                                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                                        .foregroundColor(Constants.secondaryColor)
                                }
                                .frame(height: 50)
                                .padding(.horizontal, 20)
                                .background(viewModel.sortedPlayerScores[index].isSelf ? Constants.primaryColor : Constants.primaryColor.opacity(0.2))
                            }
                        }.cornerRadius(10)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            if(showGameViewFromRoute == .JoinGameView){
                viewModel.gameState = .waiting
            }else if(showGameViewFromRoute == .StartGameView){
                viewModel.startGame()
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(showGameViewFromRoute: .constant(.JoinGameView),viewModel: GameViewModel())
    }
}
