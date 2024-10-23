//
//  SplashScreen.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI
import VizbeeKit

struct SplashScreen: View {
    @State private var scale = 0.3
    
    // Animation states for each bounce
    @State private var isFirstBounceComplete = false
    @State private var isSecondBounceComplete = false
    @State private var isThirdBounceComplete = false
    @State private var isFinalBounceComplete = false
    
    var body: some View {
        ZStack {
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(.film)
                    .foregroundColor(Constants.primaryColor)
                    .scaleEffect(scale)
                    .padding(.vertical, 20)
                
                Text(StaticText.appName)
                    .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                    .foregroundColor(Constants.primaryColor)
            }
        }
        .onAppear(perform: startBounceSequence)
    }
    
    private func startBounceSequence() {
        // First bounce (largest)
        withAnimation(.easeOut(duration: 0.6)) {
            scale = 1.2 // Overshoot
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeInOut(duration: 0.3)) {
                scale = 0.9 // First bounce back
                isFirstBounceComplete = true
            }
            
            // Second bounce
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.3)) {
                    scale = 1.1 // Second overshoot
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        scale = 0.95 // Second bounce back
                        isSecondBounceComplete = true
                    }
                    
                    // Third bounce
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeOut(duration: 0.2)) {
                            scale = 1.05 // Third overshoot
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                scale = 0.98 // Third bounce back
                                isThirdBounceComplete = true
                            }
                            
                            // Final settle
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    scale = 1.0 // Final position
                                    isFinalBounceComplete = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// To handle bounce completion if needed
extension SplashScreen {
    var isAnimationComplete: Bool {
        return isFinalBounceComplete
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
