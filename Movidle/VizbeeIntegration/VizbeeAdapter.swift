//
//  VizbeeAdapter.swift
//  VizbeeDemo
//
//  Copyright © Vizbee Inc. All rights reserved.
//

import VizbeeKit

class VizbeeAdapter: NSObject, VZBAppAdapterDelegate {
    
    /**
      This adapter method is invoked by the Vizbee SDK to get
      metadata in the Vizbee format for a given video.
      - Parameter appVideoObject: The videoObject used in the app
      - Parameter successCallback: callback on successful creation of VZBVideoMetadata
      - Parameter failureCallback: callback on failure
    */
    func getVZBMetadata(fromVideo appVideoObject: Any,
                        onSuccess successCallback: @escaping (VZBVideoMetadata) -> Void,
                        onFailure failureCallback: @escaping (Error) -> Void) {
    }

    /**
      This adapter method is invoked by the Vizbee SDK to get
      streaming info in the Vizbee format for a given video.
      - Parameter appVideoObject: The videoObject used in the app
      - Parameter screenType: The target screen to which the video is being cast
      - Parameter successCallback: callback on successful creation of VZBStreamInfo
      - Parameter failureCallback: callback on failure
    */
    func getVZBStreamInfo(fromVideo appVideoObject: Any,
                          for screenType: VZBScreenType,
                          onSuccess successCallback: @escaping (VZBVideoStreamInfo) -> Void,
                          onFailure failureCallback: @escaping (Error) -> Void) {
    }

    /**
      This adapter method is invoked by the Vizbee SDK when
      the mobile app 'joins' a receiver that is already playing a video.
      The method is used by the Vizbee SDK to get metadata about the
      video playing on the receiver by using the GUID of the video.
      - Parameter guid: GUID of the video
      - Parameter successCallback: callback on successful creation of VZBVideoInfo
      - Parameter failureCallback: callback on failure
    */
    func getVideoInfo(byGUID guid: String,
                      onSuccess successCallback: @escaping (Any) -> Void,
                      onFailure failureCallback: @escaping (Error) -> Void) {
        
        // default response
        failureCallback(NSError(domain: "Not implemented", code: 2, userInfo: nil))
    }

    /**
      This adapter method is invoked by the Vizbee SDK in SmartPlay flow
      or the Disconnect flow to start playback of a video on the phone.
      - Parameter appVideoObject: app's video object
      - Parameter playHeadTime: resume position of video
      - Parameter shouldAutoPlay: indicates if the video should start auto playing
      - Parameter viewController: the presenting view controller
    */
    func playVideo(onPhone appVideoObject: Any,
                   atPosition playHeadTime: TimeInterval,
                   shouldAutoPlay: Bool,
                   presenting viewController: UIViewController) {
    }

    /**
      This adapter method is deprecated.
    */
    func goToViewController(forGUID guid: String,
                            onSuccess successCallback: @escaping (UIViewController) -> Void,
                            onFailure failureCallback: @escaping (Error) -> Void) {
    }
}
