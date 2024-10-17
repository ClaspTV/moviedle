//
//  VizbeeWrapper.swift
//  This is the template file for intializing Vizbee SDK and listening for session changes
//
import Foundation
import VizbeeKit

// ConnectionState enumeration
enum ConnectionState {
    case connected
    case disconnected
}

struct ConnectedTVInfo{
    var id = ""
    var type = ""
    var friendlyName = ""
    var model = ""
}

class VizbeeWrapper: NSObject {
  
    @objc static let shared = VizbeeWrapper()
    var isSDKInitialized: Bool = false
  
    static let kVZBCastStateChanged = "vizbee.cast.state.changed"
    static let kVZBCastState = "state"
    
    var isConnected = false
    var sessionManager: VZBSessionManager?
    
    private static let logTag = "VZBApp_VizbeeWrapper"
    
    // ------------------
    // MARK: - SDK init
    // -----------------
    
    @objc func initVizbeeSDK() {
        
        // appId
        let appId =  "vzb2000001"
        
        // app adapter
        let appAdapter = VizbeeAdapter()
        
        // options
        let options = VZBOptions()
        options.useVizbeeUIWindowAtLevel = .normal + 3
        options.uiConfig = VizbeeStyle.lightTheme
        options.customMetricsAttributes = ["Key-1_Hel10": "Value-1", "Key-2_!#l0 L": "Value-2", "Key-3": "Value-3"]
        
        // init Vizbee SDK
        initVizbeeSDK(appId: appId, appAdapter: appAdapter, options: options)
    }
    
    @objc func initVizbeeSDK(appId: String, appAdapter: VizbeeAdapter, options: VZBOptions) {
      
        if (!isSDKInitialized) {
            
            isSDKInitialized = true
            
            // initialize vizbee sdk
            Vizbee.start(withAppID: appId,
                         appAdapterDelegate: appAdapter,
                         andVizbeeOptions: options)
            
            // setup session manager
            sessionManager = Vizbee.getSessionManager()
            addSessionStateDelegate(sessionDelegate: self)
        }
    }
    
    func getConnectedTVInfo() -> ConnectedTVInfo {
        
        let vizbeeScreen = VizbeeWrapper.shared.sessionManager?.getCurrentSession()?.vizbeeScreen
        var connectedTVInfo = ConnectedTVInfo()
        connectedTVInfo.id = vizbeeScreen?.screenInfo?.deviceId ?? ""
        connectedTVInfo.friendlyName = vizbeeScreen?.screenInfo?.friendlyName ?? "TV"
        connectedTVInfo.model = vizbeeScreen?.screenInfo?.model ?? ""
        connectedTVInfo.type = vizbeeScreen?.screenType?.typeName ?? ""
        
        return connectedTVInfo
    }
    
    func send(eventName: String, eventData: Dictionary<String, Any>) {
        
        // send event
        sessionManager?.getCurrentSession().eventManager.sendEvent(
            withName: eventName,
            andData: eventData
        )
    }
}

// ----------------------------
// MARK: - Session Management
// ----------------------------
extension VizbeeWrapper: VZBSessionStateDelegate {
  
    func addSessionStateDelegate(sessionDelegate: VZBSessionStateDelegate) {
        guard let sessionManager = sessionManager else { return }
        sessionManager.add(sessionDelegate)
    }

    func onSessionStateChanged(_ newState: VZBSessionState) {
        switch newState {
        case VZBSessionState.noDeviceAvailable: fallthrough
        case VZBSessionState.notConnected:
            
            onDisconnected()
            
        case VZBSessionState.connecting:
            
            onDisconnected()
            
        case VZBSessionState.connected:
            
            onConnected()
            
        default:
            isConnected = false
        }
        // Broadcast - post cast connected notification
        NotificationCenter.default.post(name: Notification.Name(VizbeeWrapper.kVZBCastStateChanged), object: nil, userInfo: [VizbeeWrapper.kVZBCastState: newState]);
    }
  
    func onConnected() {
        isConnected = true
    }
    
    func onDisconnected() {
        if (isConnected) {
            isConnected = false
        }
    }
    
    func getConnectedScreen() -> VZBScreen? {
        return sessionManager?.getCurrentSession()?.vizbeeScreen
    }
  
    func disconnectSession() {
        sessionManager?.disconnectSession()
    }
}
