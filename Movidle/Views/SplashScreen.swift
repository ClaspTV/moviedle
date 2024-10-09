//
//  SplashScreen.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(.film)
                    .foregroundColor(Constants.primaryColor)
                    .opacity(opacity)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0)).padding(.vertical,20)
                
                Text(Constants.appName)
                    .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                    .foregroundColor(Constants.primaryColor)
                    .opacity(opacity)
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.5)) {
                self.isAnimating = true
                self.opacity = 1.0
            }
        }
    }
}

struct ContentView: View {
    @State private var isShowingSplash = true
    
    var body: some View {
        Group {
            if isShowingSplash {
                SplashScreen()
            } else {
                TVConnectionView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.isShowingSplash = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
