//
//  TVSelectionView.swift
//  Movidle
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import SwiftUI
import VizbeeHomeOSKit
import VizbeeKit

struct TVSelectionView: View {
    @Binding var path: [Route]
    @Binding var vizbeeSessionState: VZBSessionState
    @ObservedObject var viewModel: TVSelectionViewModel
    @State private var selectedDeviceId: String?
    @State private var selectedDeviceName: String?
    
    var body: some View {
        ZStack {
            Image(.splash).resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if viewModel.devices.isEmpty {
                    noDevicesFoundView
                } else {
                    VStack {
                        Text(StaticText.selectToConnect)
                            .font(.custom(Constants.fontFamily, size: Constants.primaryFontSize))
                            .foregroundColor(Constants.primaryColor)
                            .padding(.vertical, 40)
                        
                        ForEach(viewModel.devices, id: \.id) { device in
                            DeviceButton(
                                                            device: device,
                                                            isSelected: selectedDeviceId == device.id,
                                                            isConnecting: vizbeeSessionState == .connecting,
                                                            action: { selectDevice(device) }
                                                        )
                        }
                    }
                }
                
                if !viewModel.devices.isEmpty {
                    Spacer()
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        
                        Text(vizbeeSessionState != .connecting  ? StaticText.deviceNotOnList : (StaticText.connectingTo + (selectedDeviceName ?? "TV")))
                            .font(.custom(Constants.fontFamily, size: Constants.tertiaryFontSize))
                            .foregroundColor(Constants.primaryColor)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 10)
                    }
                    .padding(30)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60) // Add top padding for the back button
        }
        .navigationBarHidden(true)
        .overlay(
            CustomBackButton(action: {
                path.removeLast()
            })
            .padding(.leading, 16)
            .padding(.top, 8),
            alignment: .topLeading
        )
        .onDisappear {
            viewModel.stopDiscovery()
        }
    }
    
    private var noDevicesFoundView: some View {
        Text(StaticText.noDeviceFound)
            .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
            .foregroundColor(Constants.primaryColor)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private func selectDevice(_ device: HomeDevice) {
        selectedDeviceId = device.id
        selectedDeviceName = device.friendlyName
        if(vizbeeSessionState != .connecting){
            viewModel.selectDevice(device)
        }else{
            viewModel.clickProxyCastIcon()
        }
    }
}

struct DeviceButton: View {
    let device: HomeDevice
    let isSelected: Bool
    let isConnecting: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(device.friendlyName)
                .font(.custom(Constants.fontFamily, size: Constants.secondaryFontSize))
                .foregroundColor(Constants.secondaryColor)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Constants.primaryColor)
                .cornerRadius(25)
                .padding(.horizontal, 30)
        }
        .disabled(isConnecting && !isSelected)
        .opacity(isConnecting && !isSelected ? 0.5 : 1.0)
        .buttonStyle(PressableButtonStyle())
    }
}

// Preview
struct TVSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        TVSelectionView(path: .constant([.TVSelectionView]), vizbeeSessionState: .constant(.notConnected), viewModel: TVSelectionViewModel())
    }
}
