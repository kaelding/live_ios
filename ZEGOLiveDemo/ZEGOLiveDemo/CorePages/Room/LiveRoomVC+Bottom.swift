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
            share()
        case .beauty:
            self.faceBeautifyView.isHidden = !self.faceBeautifyView.isHidden
        case .soundEffect:
            self.musicEffectsVC.view.isHidden = false
        case .more:
            self.moreSettingView.isHidden = false
        case .apply:
            RoomManager.shared.userService.requestToCoHost(callback: nil)
            TipView.showTip(ZGLocalizedString("toast_room_applied_connection"), autoDismiss: false)
        case .cancelApply:
            TipView.dismiss()
            RoomManager.shared.userService.cancelRequestToCoHost(callback: nil)
        case .flip:
            isFrontCamera = !isFrontCamera
            RoomManager.shared.deviceService.useFrontCamera(isFrontCamera)
        case .camera(let isOpen):
            // determined but not authorized
            if !AuthorizedCheck.isCameraAuthorized() {
                AuthorizedCheck.showCameraUnauthorizedAlert(self)
                bottomView.updateCameraStatus(!isOpen)
                return
            }
            guard let coHost = localCoHost else {
                bottomView.updateCameraStatus(!isOpen)
                return
            }
            RoomManager.shared.userService.cameraOpen(!coHost.camera)
        case .mic(let isOpen):
            // determined but not authorized
            if !AuthorizedCheck.isMicrophoneAuthorized() {
                AuthorizedCheck.showMicrophoneUnauthorizedAlert(self)
                bottomView.updateMicStatus(!isOpen)
                return
            }
            guard let coHost = localCoHost else {
                bottomView.updateMicStatus(!isOpen)
                return
            }
            if coHost.isMuted {
                bottomView.updateMicStatus(!isOpen)
                TipView.showWarn(ZGLocalizedString("toast_room_muted_by_host"))
                return
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
        let role = RoomManager.shared.userService.localUserInfo?.role
        var type: LiveBottomUIType = .participant
        switch role {
        case .host: type = .host
        case .coHost: type = .coHost
        case .participant: type = .participant
        default: type = .participant
        }
        bottomView?.updateUI(type: type)
        guard let localCoHost = localCoHost else {
            bottomView?.updateMicStatus(false)
            bottomView?.updateCameraStatus(false)
            return
        }
        bottomView?.updateMicStatus(localCoHost.mic)
        bottomView?.updateCameraStatus(localCoHost.camera)
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
    
    private func share() {
        let title = "Will share this picture to you."
        let image = UIImage(named: "room_list_cover_1")! as Any
        let item: [Any] = [title, image]
        let activityVC = UIActivityViewController(activityItems: item, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
        activityVC.completionWithItemsHandler = { type, completed, items, error in
            
        }
    }
}
