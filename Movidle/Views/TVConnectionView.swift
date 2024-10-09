//
//  TVConnectionView.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//


import SwiftUI

struct TVConnectionView: View {
    @StateObject private var viewModel = TVConnectionViewModel()

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image(.splash).resizable()
                        .edgesIgnoringSafeArea(.all)
                    if viewModel.connectionState == .notConnected {
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Text(Constants.appName)
                                .font(.custom(Constants.fontFamily, size: Constants.titleFontSize))
                                .foregroundColor(.white)
                            
                            Text("The ultimate movie\nguessing game")
                                .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                                .foregroundColor(Constants.primaryColor)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 40)
                            
                            if viewModel.hasSavedUsername && !viewModel.isEditing {
                                HStack {
                                    Text("Welcome, " + viewModel.username)
                                        .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                                        .foregroundColor(.white).padding(10)
                                    
                                    Button(action: viewModel.startEditing) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(Constants.primaryColor)
                                    }.padding(10).background(Color.white.opacity(0.2)).cornerRadius(4)
                                }
                                .padding()
                                .cornerRadius(8)
                                .padding(.horizontal, 40)
                            } else {
                                UsernameTextField(text: $viewModel.username, isFocused: $viewModel.isUsernameFocused)
                                    .frame(height: 50)
                                    .padding(.horizontal, 40)
                                
                                Text(viewModel.usernameValidationMessage)
                                    .font(.custom(Constants.fontFamily, size: 14))
                                    .foregroundColor(viewModel.isUsernameValid ? .green : .red)
                                    .padding(.horizontal, 40)
                            }
                            
                            Spacer()
                            
                            Button(action: viewModel.connectToTV) {
                                Text("Connect To TV")
                                    .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                                    .foregroundColor(Constants.secondaryColor)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(viewModel.isUsernameValid ? Constants.primaryColor : Color.gray)
                                    .cornerRadius(50)
                                    .padding(.horizontal, 40)
                            }
                            .disabled(!viewModel.isUsernameValid)
                            .padding(.horizontal, 40)
                            
                            Spacer()
                        }
                        .animation(.easeOut(duration: 0.25))
                    } else {
                        TVConnectingView(viewModel: viewModel)
                    }
                }
            }
            .onTapGesture {
                viewModel.dismissKeyboard()
            }
        }
    }
}


// Custom TextField to handle focus for iOS 13
struct UsernameTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.textColor = UIColor(Constants.primaryColor)
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        textField.attributedPlaceholder = NSAttributedString(string: "Enter username", attributes: [NSAttributedString.Key.foregroundColor: UIColor(Constants.primaryColor).withAlphaComponent(0.5)])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFocused {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: UsernameTextField
        
        init(_ parent: UsernameTextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isFocused = true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.isFocused = false
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}

// Preview
struct TVConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        TVConnectionView()
    }
}
