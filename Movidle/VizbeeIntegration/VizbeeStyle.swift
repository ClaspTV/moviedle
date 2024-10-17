import Foundation
import VizbeeKit

class VizbeeStyle: NSObject {
    
    //----------------------------
    // MARK : - Light Theme
    //---------------------------

    @objc
    static let lightTheme: [String: Any] =  [
        
        "base": "LightTheme",
        
        "references": [
            "@primaryFont"        : Constants.fontFamily,
            "@secondaryFont"      : Constants.fontFamily,
            
            "@primaryColor": "#000000",
            "@secondaryColor": "#FFFFFF",
            "@tertiaryColor": "#FFFFFF",
            
            "@titleLabel": [
                "textTransform": nil,
            ],
            "@subtitleLabel": [
                "textTransform": nil,
            ],
            "@overlayTitleLabel": [
                "textTransform": nil,
            ],
            "@overlaySubtitleLabel": [
                "textTransform": nil,
            ],
            
            "@buttons" : [
                "margin" : [18,60,18,60],
                "cornerRadius": 30,
                "textTransform": nil,
            ]
        ],
        
        "ids" : [

        ],
        
        "classes": [
            "DeviceInfoView.DeviceNameLabel": [
                "textTransform": nil,
            ],
            "DeviceStatusView.DeviceStatusLabel": [
                "textTransform": nil,
            ],
            
            "BackgroundLayer": [
                    "backgroundType"  : "image",
                    "backgroundImageName" : "splash"
                    ],
            
            //---
            // Buttons
            //---
            
            "CallToActionButton": "@buttons",
            "OverlayCallToActionButton": "@buttons",
            "RefreshButton" : [
                "margin" : [18,60,18,60],
                "font" : [
                    "style": "callout"
                ],
                "backgroundColor" : "none",
                "textColor" : "#C20017"
            ],
            "OverlayCloseButton" : [
                "image" : "close",
            ],
        ]
    ]
}

