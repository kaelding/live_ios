//
//  LiveRoomVC+Setting.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/6.
//

import Foundation

extension LiveRoomVC: LiveSettingViewDelegate, LiveSettingSecondViewDelegate {
 
    func settingViewDidSelected(_ model: LiveSettingModel) {
        switch model.selectionType {
        case .resolution:
            self.liveSettingView?.isHidden = true
            self.resolutionView?.isHidden = false
        case .bitrate:
            self.liveSettingView?.isHidden = true
            self.bitrateView?.isHidden = false
        case .encoding:
            self.liveSettingView?.isHidden = true
            self.encodingView?.isHidden = false
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
        self.liveSettingView?.isHidden = false
        self.liveSettingView?.updateUI()
    }
}
