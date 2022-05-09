//
//  FaceBeautifyService.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/29.
//

import UIKit
import ZegoExpressEngine


/// Class face beautify
///
/// Description: This class contains the face beautification, face shape retouch feature related information.
enum FaceBeautifyType {
    /// Skin tone enhancement
    case SkinToneEnhancement
    
    /// Skin smoothing
    case SkinSmoothing
    
    /// Image sharpening
    case ImageSharpening
    
    /// Cheek blusher
    case CheekBlusher
}

/// Class face beautify management
///
/// Description: This class contains the enabling/disabling logic, and the parameter setting logic of the face beautify feature.
class FaceBeautifyService: NSObject {
    
    let beautyParam = ZegoEffectsBeautyParam()
    
    
    /// Enable the face beautify feature (include the face beautification and face shape retouch).
    ///
    /// Description: When this method gets called, the captured video streams will be processed before publishing to the remote users.
    ///
    /// Call this method at: When joining a room
    ///
    /// @param enable determines whether to enable or disable the the face beautify feature.  true: enable.  false: disable.
    /// @param type refers to the specific face beautify type that has been enabled
    public func enableBeautify(_ enable: Bool) {
        ZegoExpressEngine.shared().enableEffectsBeauty(enable)
    }
    
    
    /// Set the intensity of the specific face beautify feature
    ///
    /// Description: After the face beautify feature is enabled, you can specify the parameters to set the intensity of the specific feature as needed.
    ///
    /// Call this method at: After enabling the face beautify feature.
    ///
    /// @param value: refers to the range value of the specific face beautification feature or face shape retouch feature.
    /// @param type: refers to the specific face beautification feature or face shape retouch feature.
    public func setBeautifyValue(_ value: Int32, type: FaceBeautifyType) {
        switch type {
        case .SkinToneEnhancement:
            self.beautyParam.whitenIntensity = value
        case .SkinSmoothing:
            self.beautyParam.smoothIntensity = value
        case .ImageSharpening:
            self.beautyParam.sharpenIntensity = value
        case .CheekBlusher:
            self.beautyParam.rosyIntensity = value
        }
        ZegoExpressEngine.shared().setEffectsBeautyParam(self.beautyParam)
    }
    
    
    /// Reset basic beauty parameters
    public func resetBeauty() {
        self.beautyParam.whitenIntensity = 50
        self.beautyParam.smoothIntensity = 50
        self.beautyParam.sharpenIntensity = 50
        self.beautyParam.rosyIntensity = 5
        ZegoExpressEngine.shared().setEffectsBeautyParam(self.beautyParam)
    }
}
