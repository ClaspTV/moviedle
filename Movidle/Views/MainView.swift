//
//  MainView.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @State private var isShowingSplash = true
    @State private var tvConnectionOffset: CGFloat = 500
    @State private var tvConnectionOpacity: Double = 0
    @State var connectionViewPath = [Route]()
    @State var connectedViewPath = [Route]()
    
    @ObservedObject var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
            if isShowingSplash {
                SplashScreen()
            }else if(viewModel.showGameViewFromRoute != nil){
                GameView(showGameViewFromRoute: $viewModel.showGameViewFromRoute,
                    viewModel:GameViewModel())
            }else{
                NavigationStack(path: viewModel.vizbeeSessionState == .connected ? $connectedViewPath: $connectionViewPath) {
                    if(viewModel.vizbeeSessionState == .connected){
                        ConnectedView(path: $connectedViewPath,
                                      viewModel: ConnectedViewModel())
                        .navigationDestination(for: Route.self) { index in
                            
                            switch index {
                                
                            case .JoinGameView:
                                JoinGameView(path: $connectedViewPath,
                                             showGameViewFromRoute: $viewModel.showGameViewFromRoute,
                                             viewModel: JoinGameViewModel())
                                
                            case .StartGameView:
                                StartGameView(path: $connectedViewPath,
                                              showGameViewFromRoute: $viewModel.showGameViewFromRoute,
                                              viewModel: StartGameViewModel())
                                
                            case .TVDisconnectView:
                                TVDisconnectView(path: $connectedViewPath,
                                                 vizbeeSessionState:$viewModel.vizbeeSessionState,
                                                 viewModel: TVDisconnectViewModel())
                                
                            default:
                                EmptyView()
                            }
                        }
                    }else{
                        TVConnectionView(path: $connectionViewPath, vizbeeSessionState: $viewModel.vizbeeSessionState)
                            .offset(x: tvConnectionOffset)
                            .opacity(tvConnectionOpacity)
                        
                            .navigationDestination(for: Route.self) { index in
                                
                                switch index {
                                    
                                case .TVSelectionView:
                                    TVSelectionView(path: $connectionViewPath, vizbeeSessionState: $viewModel.vizbeeSessionState,
                                                    viewModel:TVSelectionViewModel())
                                    
                                default:
                                    EmptyView()
                                }
                            }
                    }
                }
            }
        }
        .onChange(of: viewModel.vizbeeSessionState) { newValue in
            if(newValue == .connected){
                connectionViewPath.removeAll()
            } else {
                connectedViewPath.removeAll()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    self.isShowingSplash = false
                    self.tvConnectionOffset = 0
                    self.tvConnectionOpacity = 1
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
