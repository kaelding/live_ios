//
//  LiveRoomVC+Bottom.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation

extension LiveRoomVC : LiveBottomViewDelegate {
    
    func liveBottomView(_ bottomView: LiveBottomView, didClickButtonWith action: LiveBottomAction) {
        print("liveBottomView did click button: \(action)")
        switch action {
        case .message:
            messageButtonClick()
        case .share:
            print("liveBottomView did click button: \(action)")
        case .beauty:
            self.faceBeautifyView.isHidden = !self.faceBeautifyView.isHidden
        case .soundEffect:
            print("liveBottomView did click button: \(action)")
            self.musicEffectsVC.view.isHidden = false
        case .more:
            self.moreSettingView.isHidden = false
                print("liveBottomView did click button: \(action)")
        case .apply:
            if applicationHasMicAndCameraAccess() {
                RoomManager.shared.userService.requestToCoHost(callback: nil)
                TipView.showTip(ZGLocalizedString("room_apply_to_connect_tip"))
            } else {
                bottomView.resetApplyStatus()
            }
        case .cancelApply:
            RoomManager.shared.userService.cancelRequestToCoHost(callback: nil)
        case .flip:
                print("liveBottomView did click button: \(action)")
        case .camera:
                print("liveBottomView did click button: \(action)")
        case .mic:
                print("liveBottomView did click button: \(action)")
        case .end:
                print("liveBottomView did click button: \(action)")
        }
    }
    
    func messageButtonClick() {
        inputTextView.isHidden = false
        inputTextView.textViewBecomeFirstResponse()
    }
}

extension LiveRoomVC {
    private func applicationHasMicAndCameraAccess() -> Bool {
        // not determined
        if !AuthorizedCheck.isCameraAuthorizationDetermined(){
            AuthorizedCheck.takeCameraAuthorityStatus(completion: nil)
            return false
        }
        // determined but not authorized
        if !AuthorizedCheck.isCameraAuthorized() {
            AuthorizedCheck.showCameraUnauthorizedAlert(self)
            return false
        }
        
        // not determined
        if !AuthorizedCheck.isMicrophoneAuthorizationDetermined(){
            AuthorizedCheck.takeMicPhoneAuthorityStatus(completion: nil)
            return false
        }
        // determined but not authorized
        if !AuthorizedCheck.isMicrophoneAuthorized() {
            AuthorizedCheck.showMicrophoneUnauthorizedAlert(self)
            return false
        }
        return true
    }
}
