//
//  FaceBeautifyService.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/29.
//

import UIKit
import ZegoEffects


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
    
    /// Eyes enlarging
    case EyesEnlarging
    
    /// Face sliming
    case FaceSliming
    
    /// Mouth shape adjustment
    case MouthShapeAdjustment
    
    /// Eyes brightening
    case EyesBrightening
    
    /// Nose sliming
    case NoseSliming
    
    /// Chin lengthening
    case ChinLengthening
    
    /// Teeth whitening
    case TeethWhitening
}

/// Class face beautify management
///
/// Description: This class contains the enabling/disabling logic, and the parameter setting logic of the face beautify feature.
class FaceBeautifyService: NSObject {
    
    /// Class ZegoEffects SDK instances
    lazy var effects: ZegoEffects = {
        return ZegoEffects.create(EffectsLicense.shared.license)
    }()
    
    let skinToneEnhancementParam = ZegoEffectsWhitenParam()
    let skinSmoothingParam = ZegoEffectsSmoothParam()
    let imageSharpeningParam = ZegoEffectsSharpenParam()
    let cheekBlusherParam = ZegoEffectsRosyParam()
    let eyesEnlargingParam = ZegoEffectsBigEyesParam()
    let faceSlimingParam = ZegoEffectsFaceLiftingParam()
    let mouthShapeAdjustmentParam = ZegoEffectsSmallMouthParam()
    let eyesBrighteningParam = ZegoEffectsEyesBrighteningParam()
    let noseSlimingParam = ZegoEffectsNoseNarrowingParam()
    let chinLengtheningParam = ZegoEffectsLongChinParam()
    let teethWhiteningParam = ZegoEffectsTeethWhiteningParam()
    
    /// Set  Effects resource path
    /// Contact technical support to download the resources that ZegoEffects SDK required, and put the resources you get into your project.
    /// Call this method at: After initializing the SDK
    public func setResources(_ resourceInfoList: [String]) {
        ZegoEffects.setResources(resourceInfoList)
    }
    
    /// Enable the face beautify feature (include the face beautification and face shape retouch).
    ///
    /// Description: When this method gets called, the captured video streams will be processed before publishing to the remote users.
    ///
    /// Call this method at: When joining a room
    ///
    /// @param enable determines whether to enable or disable the the face beautify feature.  true: enable.  false: disable.
    /// @param type refers to the specific face beautify type that has been enabled
    public func enableBeautify(_ enable: Bool, type: FaceBeautifyType) {
        switch type {
        case .SkinToneEnhancement:
            effects.enableWhiten(enable)
        case .SkinSmoothing:
            effects.enableSmooth(enable)
        case .ImageSharpening:
            effects.enableSharpen(enable)
        case .CheekBlusher:
            effects.enableRosy(enable)
        case .EyesEnlarging:
            effects.enableBigEyes(enable)
        case .FaceSliming:
            effects.enableFaceLifting(enable)
        case .MouthShapeAdjustment:
            effects.enableSmallMouth(enable)
        case .EyesBrightening:
            effects.enableEyesBrightening(enable)
        case .NoseSliming:
            effects.enableNoseNarrowing(enable)
        case .ChinLengthening:
            effects.enableLongChin(enable)
        case .TeethWhitening:
            effects.enableTeethWhitening(enable)
        }
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
            self.skinToneEnhancementParam.intensity = value
            effects.setWhitenParam(self.skinToneEnhancementParam)
        case .SkinSmoothing:
            self.skinSmoothingParam.intensity = value
            effects.setSmoothParam(self.skinSmoothingParam)
        case .ImageSharpening:
            self.imageSharpeningParam.intensity = value
            effects.setSharpenParam(self.imageSharpeningParam)
        case .CheekBlusher:
            self.cheekBlusherParam.intensity = value
            effects.setRosyParam(self.cheekBlusherParam)
        case .EyesEnlarging:
            self.eyesEnlargingParam.intensity = value
            effects.setBigEyesParam(self.eyesEnlargingParam)
        case .FaceSliming:
            self.faceSlimingParam.intensity = value
            effects.setFaceLiftingParam(self.faceSlimingParam)
        case .MouthShapeAdjustment:
            self.mouthShapeAdjustmentParam.intensity = value
            effects.setSmallMouthParam(self.mouthShapeAdjustmentParam)
        case .EyesBrightening:
            self.eyesBrighteningParam.intensity = value
            effects.setEyesBrighteningParam(self.eyesBrighteningParam)
        case .NoseSliming:
            self.noseSlimingParam.intensity = value
            effects.setNoseNarrowingParam(self.noseSlimingParam)
        case .ChinLengthening:
            self.chinLengtheningParam.intensity = value
            effects.setLongChinParam(self.chinLengtheningParam)
        case .TeethWhitening:
            self.teethWhiteningParam.intensity = value
            effects.setTeethWhiteningParam(self.teethWhiteningParam)
        }
    }
}
