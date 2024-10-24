import SwiftUI

struct MainView: View {
    @State private var isShowingSplash = true
    @State private var tvConnectionOffset: CGFloat = 500
    @State private var tvConnectionOpacity: Double = 0
    @State private var activeRoute: Route?
    
    @ObservedObject var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
            if isShowingSplash {
                SplashScreen()
            } else if viewModel.showGameViewFromRoute != nil {
                GameView(showGameViewFromRoute: $viewModel.showGameViewFromRoute,
                        viewModel: GameViewModel())
            } else {
                Group {
                    if viewModel.vizbeeSessionState == .connected {
                        NavigationView {
                            ConnectedView(activeRoute: $activeRoute,
                                          showGameViewFromRoute: $viewModel.showGameViewFromRoute,
                                          viewModel: ConnectedViewModel())
                                .navigationBarHidden(true)
                                .background(
                                    Group {
                                        // Wrap NavigationLinks in if statements to prevent initialization issues
                                        if activeRoute == .JoinGameView || activeRoute == nil {
                                            NavigationLink(
                                                destination: JoinGameView(activeRoute: $activeRoute,
                                                                        showGameViewFromRoute: $viewModel.showGameViewFromRoute,
                                                                        viewModel: JoinGameViewModel()),
                                                tag: Route.JoinGameView,
                                                selection: $activeRoute) {
                                                    EmptyView()
                                                }
                                        }
                                        
                                        if activeRoute == .StartGameView || activeRoute == nil {
                                            NavigationLink(
                                                destination: StartGameView(activeRoute: $activeRoute,
                                                                           showGameViewFromRoute: $viewModel.showGameViewFromRoute,
                                                                           viewModel: StartGameViewModel()),
                                                tag: Route.StartGameView,
                                                selection: $activeRoute) {
                                                    EmptyView()
                                                }
                                        }
                                        
                                        if activeRoute == .TVDisconnectView || activeRoute == nil {
                                            NavigationLink(
                                                destination: TVDisconnectView(activeRoute: $activeRoute,
                                                                              vizbeeSessionState: $viewModel.vizbeeSessionState,
                                                                              viewModel: TVDisconnectViewModel()),
                                                tag: Route.TVDisconnectView,
                                                selection: $activeRoute) {
                                                    EmptyView()
                                                }
                                        }
                                    }
                                )
                        }
                    } else {
                        NavigationView {
                            TVConnectionView(activeRoute: $activeRoute,
                                           vizbeeSessionState: $viewModel.vizbeeSessionState)
                                .offset(x: tvConnectionOffset)
                                .opacity(tvConnectionOpacity)
                                .navigationBarHidden(true)
                                .background(
                                    Group {
                                        // Wrap in if statement
                                        if activeRoute == .TVSelectionView || activeRoute == nil {
                                            NavigationLink(
                                                destination: TVSelectionView(activeRoute: $activeRoute,
                                                                             vizbeeSessionState: $viewModel.vizbeeSessionState,
                                                                             viewModel: TVSelectionViewModel()),
                                                tag: Route.TVSelectionView,
                                                selection: $activeRoute) {
                                                    EmptyView()
                                                }
                                        }
                                    }
                                )
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.vizbeeSessionState) { newValue in
            // Add dispatch to main queue and wrap in withAnimation
            DispatchQueue.main.async {
                withAnimation {
                    activeRoute = nil
                }
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
