//
//  LiveRoomVC+Setting.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/6.
//

import Foundation
import ZegoExpressEngine

extension LiveRoomVC: LiveSettingViewDelegate, LiveSettingSecondViewDelegate, MoreSettingViewDelegate {
    
    func settingViewDidSelected(_ model: LiveSettingModel, type: LiveSettingViewType) {
        switch model.selectionType {
        case .resolution:
            if type == .nomal {
                self.liveSettingView?.isHidden = true
                self.resolutionView?.isHidden = false
            } else {
                self.LivingSettingView?.isHidden = true
                self.resolutionView?.isHidden = false
            }
        case .bitrate:
            if type == .nomal {
                self.liveSettingView?.isHidden = true
                self.bitrateView?.isHidden = false
            } else {
                self.LivingSettingView?.isHidden = true
                self.bitrateView?.isHidden = false
            }
        case .encoding:
            if type == .nomal {
                self.liveSettingView?.isHidden = true
                self.encodingView?.isHidden = false
            } else {
                self.LivingSettingView?.isHidden = true
                self.encodingView?.isHidden = false
            }
        case .layered:
            return
        case .hardware:
            return
        case .decoding:
            return
        case .noise:
            return
        case .echo:
            return
        case .volume:
            return
        }
    }
    
    func settingSecondViewDidBack() {
        if self.isLiving {
            self.LivingSettingView?.isHidden = false
            self.LivingSettingView?.updateUI()
        } else {
            self.liveSettingView?.isHidden = false
            self.liveSettingView?.updateUI()
        }
        
    }
    
    func moreSettingViewDidSelectedCell(_ type: MoreSettingViewSelectedType) {
        switch type {
        case .flip:
            isFrontCamera = !isFrontCamera
            ZegoExpressEngine.shared().useFrontCamera(isFrontCamera)
        case .camera:
            guard let coHost = localCoHost else { break }
            RoomManager.shared.userService.cameraOpen(!coHost.camera)
        case .mic:
            guard let coHost = localCoHost else { break }
            RoomManager.shared.userService.micOperation(!coHost.mic)
        case .setting:
            self.moreSettingView.isHidden = true
            self.LivingSettingView?.isHidden = false
        }
    }
}
