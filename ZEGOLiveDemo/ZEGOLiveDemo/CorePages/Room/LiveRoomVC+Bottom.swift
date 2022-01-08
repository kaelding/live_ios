//
//  LiveRoomVC+Bottom.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation
import ZegoExpressEngine

extension LiveRoomVC : LiveBottomViewDelegate {
    
    func liveBottomView(_ bottomView: LiveBottomView, didClickButtonWith action: LiveBottomAction) {
        switch action {
        case .message:
            messageButtonClick()
        case .share:
            print("liveBottomView did click button: \(action)")
        case .beauty:
            self.faceBeautifyView.isHidden = !self.faceBeautifyView.isHidden
        case .soundEffect:
            self.musicEffectsVC.view.isHidden = false
        case .more:
            self.moreSettingView.isHidden = false
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
            isFrontCamera = !isFrontCamera
            ZegoExpressEngine.shared().useFrontCamera(isFrontCamera)
        case .camera:
            guard let coHost = localCoHost else { break }
            RoomManager.shared.userService.cameraOpen(!coHost.camera)
        case .mic:
            guard let coHost = localCoHost else { break }
            if coHost.isMuted {
                TipView.showWarn(ZGLocalizedString("toast_room_muted_by_host"))
                break
            }
            RoomManager.shared.userService.micOperation(!coHost.mic)
        case .end:
            endCoHost()
        }
    }
    
    func messageButtonClick() {
        inputTextView.isHidden = false
        inputTextView.textViewBecomeFirstResponse()
    }
}

extension LiveRoomVC {
    
    func updateBottomView() {
        bottomView?.updateUI(type: getBottomUIType())
    }
    
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
    
    private func endCoHost() {
        let title = ZGLocalizedString("toast_room_title_ended_the_connection")
        let message = ZGLocalizedString("dialog_room_message_ended_the_connection")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_cancel"), style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_ok"), style: .default) { action in
            RoomManager.shared.userService.leaveCoHostSeat { result in
                if result.isFailure {
                    TipView.showWarn(ZGLocalizedString("toast_room_failed_to_operate"))
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
