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
                        .padding(.bottom, 80)
//                    Text("00:\(String(format: "%02d", viewModel.timeLeft))")
//                        .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
//                        .foregroundColor(Constants.primaryColor)
//                    Text(StaticText.timeLeft)
//                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
//                        .foregroundColor(Constants.primaryColor)
//                        .padding(.bottom, 40)
                    if(viewModel.guessRightAnswerForMovieNumber != nil){
                        Text(StaticText.guessRight)
                            .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                            .foregroundColor(Constants.primaryColor)
                            .padding(.horizontal,20)
                        
                        Text(StaticText.guessWait)
                            .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                            .foregroundColor(Constants.primaryColor)
                    }else{
                        StyledTextField(text: $viewModel.userGuess, placeholder: StaticText.typeYourGuess)
                            .padding(.horizontal, 80)
                        
                        // Add error message here
                        if let errorMessage = viewModel.guessErrorMessage {
                            Text(errorMessage)
                                .font(.custom(Constants.fontFamily, size: Constants.tertiaryFontSize))
                                .foregroundColor(Constants.redColor)  // or use a custom error color from Constants
                                .padding(.top, 8)
                                .padding(.horizontal, 80)
                        }
                        
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
                    }
                case .completed:
                    ZStack(alignment: .top) {
                        // Content in ScrollView
                        GeometryReader { geometry in
                            ScrollView {
                                VStack {
                                    // Film clapper icon
                                    Image(.film)
                                        .foregroundColor(Constants.primaryColor)
                                        .padding(.top, 20)
                                    
                                    Text(viewModel.movieTitle)
                                        .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                                        .foregroundColor(Constants.primaryColor)
                                        .padding()
                                    Text(StaticText.yourScore)
                                        .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                                        .foregroundColor(Constants.primaryColor)
                                    Text("\(viewModel.userScore)")
                                        .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                                        .foregroundColor(Constants.primaryColor)
                                    
                                    VStack(spacing: 1) {
                                        ForEach(viewModel.sortedPlayerScores.indices, id: \.self) { index in
                                            HStack {
                                                Text("\(index + 1).")
                                                    .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                                                    .foregroundColor(Constants.secondaryColor)
                                                
                                                // Avatar Image
                                                CachedAsyncImage(url: viewModel.sortedPlayerScores[index].avatar)
                                                    .frame(width: 30, height: 30)
                                                    .clipShape(Circle())
                                                    .background(Circle().fill(Color.gray.opacity(0.2)))
                                                
                                                Text(viewModel.sortedPlayerScores[index].name)
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
                                    }
                                    .cornerRadius(10)
                                }
                                .padding()
                                .frame(minWidth:geometry.size.width, minHeight: geometry.size.height - 60)
                            }
                        }
                        if(viewModel.isCompleted){
                            HStack {
                                Spacer()
                                Button(action: {
                                    showGameViewFromRoute = nil
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 20))
                                        .foregroundColor(Constants.primaryColor)
                                        .frame(width: 44, height: 44)
                                        .background(Circle().fill(Constants.primaryColor.opacity(0.2)))
                                }
                                .buttonStyle(PressableButtonStyle())
                                .padding(.trailing, 16)
                            }
                            .padding(.top, 16)
                        }
                    }
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
