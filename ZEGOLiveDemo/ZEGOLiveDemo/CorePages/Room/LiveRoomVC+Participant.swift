//
//  LiveRoomVC+Participant.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2022/1/7.
//

import Foundation
import ZIM
import ZegoExpressEngine

extension LiveRoomVC: ParticipantListViewDelegate {
    func invitedUserAddCoHost(userInfo: UserInfo) {
        if RoomManager.shared.userService.coHostList.count >= 4 {
            TipView.showTip(ZGLocalizedString("toast_room_maximum"))
            return
        }
        guard let userID = userInfo.userID else { return }
        RoomManager.shared.userService.addCoHost(userID, callback: { result in
            switch result {
            case .success:
                self.participantListView.inviteMaskView.isHidden = true
                self.reloadParticipantListView()
                self.restoreInvitedUserStatus(userInfo)
                break
            case .failure(_):
                TipView.showWarn(ZGLocalizedString("toast_user_list_page_connected_failed"))
                break
            }
        })
    }
    
    // MARK: private method
    func restoreInvitedUserStatus(_ userInfo: UserInfo) {
        guard let userID = userInfo.userID else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
            
            if let userInfo = RoomManager.shared.userService.userList.getObj(userID) {
                userInfo.hasInvited = false
                self.reloadParticipantListView()
            }
        }
    }
    
    func reloadParticipantListView() {
        
        func getDataSource() -> [UserInfo] {
            
            var dataSource = [UserInfo]()
            if let host = getHost() {
                dataSource.append(host)
            }
            
            if let localUser = localUser {
                if localUser.role != .host { dataSource.append(localUser) }
            }
            
            let coHost = RoomManager.shared.userService.userList.allObjects().filter {
                $0.role == .coHost && $0.userID != localUserID
            }
            dataSource.append(contentsOf: coHost)
            
            
            let participants = RoomManager.shared.userService.userList.allObjects().filter {
                $0.role == .participant && $0.userID != localUserID
            }
            dataSource.append(contentsOf: participants)
            
            return dataSource
        }
        participantListView.reloadListView(getDataSource())
    }
}

extension LiveRoomVC: UserServiceDelegate {
    func connectionStateChanged(_ state: ZIMConnectionState, _ event: ZIMConnectionEvent) {
        if state == .disconnected {
            TipView.dismiss()
            self.view.isUserInteractionEnabled = true
            if event == .loginTimeout {
                showNetworkAlert()
            } else {
                // disconnect of room end
                var message = ZGLocalizedString("toast_disconnect_tips")
                if event == .success {
                    receiveRoomEnded()
                    return
                }
                else if event == .kickedOut {
                    message = ZGLocalizedString("toast_kickout_error")
                }
                TipView.showWarn(message)
                logout()
            }
        } else if state == .reconnecting {
            TipView.showWarn(ZGLocalizedString("network_reconnect"), autoDismiss: false)
            self.view.isUserInteractionEnabled = false
        } else if state == .connected {
            TipView.dismiss()
            self.view.isUserInteractionEnabled = true
        }
        
        func showNetworkAlert() {
            let title = ZGLocalizedString("network_connect_failed_title")
            let message = ZGLocalizedString("network_connect_failed")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: ZGLocalizedString("dialog_confirm"), style: .default) { action in
                self.logout()
            }
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    func roomUserJoin(_ users: [UserInfo]) {
        
        var tempList: [MessageModel] = []
        for user in users {
            if user.userID == localUserID {
                tempList.removeAll()
                break
            }
            let model: MessageModel = MessageModelBuilder.buildJoinMessageModel(user: user)
            tempList.append(model)
        }
        messageList.append(contentsOf: tempList)
        
        reloadMessageData()
        reloadParticipantListView()
        updateTopView()
        updateBottomView()
        
        // if it is host enter the room, host's camera and mic should be on.
        if !isMyselfHost {
            updateHostBackgroundView()
        }
    }
    
    func roomUserLeave(_ users: [UserInfo]) {
        
        for user in users {
            if user.userID == localUserID { continue }
            let model: MessageModel = MessageModelBuilder.buildLeftMessageModel(user: user)
            messageList.append(model)
        }
        
        reloadMessageData()
        reloadParticipantListView()
        updateTopView()
    }
    
    func receiveAddCoHostInvitation() {
        let title = ZGLocalizedString("dialog_invition_title")
        let message = ZGLocalizedString("dialog_invition_descrip")
        let inviteAlter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_disagree"), style: .cancel) { action in
            RoomManager.shared.userService.respondCoHostInvitation(false, callback: nil)
        }
        let okAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_agree"), style: .default)
        { [weak self] action in
            
            if RoomManager.shared.userService.coHostList.count >= 4 {
                TipView.showWarn(ZGLocalizedString("toast_room_maximum"))
                return
            }
            
            self?.startMonitorCameraAndMicAuthority()
        }
        
        inviteAlter.addAction(cancelAction)
        inviteAlter.addAction(okAction)
        self.present(inviteAlter, animated: true, completion: nil)
    }
    /// receive add co-host invitation respond
    func receiveAddCoHostRespond(_ userInfo: UserInfo, accept: Bool) {
        guard let user = RoomManager.shared.userService.userList.getObj(userInfo.userID ?? "") else { return }
        user.hasInvited = false
        
        if accept == false {
            let message = String(format: ZGLocalizedString("toast_user_list_page_rejected_invitation"), user.userName ?? "")
            TipView.showWarn(message)
        }
        reloadParticipantListView()
    }
    /// receive request to co-host request
    func receiveToCoHostRequest(_ userInfo: UserInfo) {
        coHostTask.addTask(hostReceiveCoHostRequest, user: userInfo)
    }
    /// receive cancel request to co-host
    func receiveCancelToCoHostRequest(_ userInfo: UserInfo) {
        guard let name = userInfo.userName else { return }
        let message = String(format: ZGLocalizedString("toast_room_has_canceled_connection_apply"), name)
        TipView.showTip(message)
        
        coHostTask.finish()
        if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    /// receive response to request to co-host
    func receiveToCoHostRespond(_ agree: Bool) {
        TipView.dismiss()
        if agree {
            if RoomManager.shared.userService.coHostList.count >= 4 {
                TipView.showTip(ZGLocalizedString("toast_room_maximum"))
                bottomView?.resetApplyStatus()
                return
            }
            RoomManager.shared.userService.takeSeat(callback: nil)
        } else {
            TipView.showTip(ZGLocalizedString("toast_room_has_rejected"))
        }
        bottomView?.resetApplyStatus()
        requestTimer.stop()
    }
    
    func coHostChange(_ targetUserID: String, type: CoHostChangeType) {
        reloadCoHost()
        updateBottomView()
        updateHostBackgroundView()
        reloadParticipantListView()
                
        // if local user leave the seat, it must stop preview
        // if not, when use the same view to play stream, the view will show the preview image
        if targetUserID == localUserID && (type == .leave || type == .remove) {
            RoomManager.shared.deviceService.stopPlayStream(targetUserID)
        }
        
        // be removed by host
        if type == .remove && isUserMyself(targetUserID) {
            TipView.showTip(ZGLocalizedString("toast_room_prohibited_connection"))
        }
        
        if isMyselfHost && type == .leave && !isUserMyself(targetUserID) {
            if let user = getUser(targetUserID) {
                TipView.showTip(String(format: ZGLocalizedString("toast_room_ended_the_connection"), user.userName ?? ""))
            }
        }
        
        guard let coHost = getCoHost(targetUserID) else { return }
        if coHost.isMuted && type == .mute && isUserMyself(coHost.userID) {
            TipView.showTip(ZGLocalizedString("toast_room_muted_by_host"))
        }
        // unmute by host, then open the mic.
        if !coHost.isMuted && type == .mute && isUserMyself(coHost.userID) {
            RoomManager.shared.userService.micOperation(true)
        }
    }
}

extension LiveRoomVC {
    private func startMonitorCameraAndMicAuthority() {
        micCameraTimer.setEventHandler { [weak self] in
            self?.onMicCameraAuthorizationTimerTriggered()
        }
        micCameraTimer.start()
    }
    
    private func onMicCameraAuthorizationTimerTriggered() {
        if !AuthorizedCheck.isMicrophoneAuthorizationDetermined() {
            AuthorizedCheck.takeMicPhoneAuthorityStatus(completion: nil)
            return
        }
        if !AuthorizedCheck.isCameraAuthorizationDetermined() {
            AuthorizedCheck.takeCameraAuthorityStatus(completion: nil)
            return
        }
        
        // if do not have mic access
        if !AuthorizedCheck.isMicrophoneAuthorized() {
            micCameraTimer.stop()
            RoomManager.shared.userService.respondCoHostInvitation(false, callback: nil)
            AuthorizedCheck.showMicrophoneUnauthorizedAlert(self)
            return
        }
        
        // if do not have camera access
        if !AuthorizedCheck.isCameraAuthorized() {
            micCameraTimer.stop()
            RoomManager.shared.userService.respondCoHostInvitation(false, callback: nil)
            AuthorizedCheck.showCameraUnauthorizedAlert(self)
            return
        }
        micCameraTimer.stop()
        
        // if have mic and camera access, just take seat.
        if RoomManager.shared.userService.coHostList.compactMap({ $0.userID }).contains(localUserID) {
            // already on seat
            return
        }
        RoomManager.shared.userService.takeSeat { result in
            switch result {
            case .success:
                RoomManager.shared.userService.respondCoHostInvitation(true, callback: nil)
                break
            case .failure(_):
                RoomManager.shared.userService.respondCoHostInvitation(false, callback: nil)
            }
        }
    }
    
    private func hostReceiveCoHostRequest(_ userInfo: UserInfo) {
        guard let name = userInfo.userName,
              let userID = userInfo.userID else {
            self.coHostTask.finish()
            return
        }
        let title = ZGLocalizedString("dialog_room_page_title_connection_request")
        let message = String(format: ZGLocalizedString("dialog_room_page_message_connection_request"), name)
        let inviteAlter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_disagree"), style: .cancel) { action in
            self.coHostTask.finish()
            RoomManager.shared.userService.respondCoHostRequest(false, userID) { result in
                switch result {
                case .success:
                    break
                case .failure(_):
                    TipView.showWarn(ZGLocalizedString("toast_room_failed_to_operate"))
                    break
                }
            }
        }
        let okAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_agree"), style: .default) { action in
            self.coHostTask.finish()
            RoomManager.shared.userService.respondCoHostRequest(true, userID) { result in
                switch result {
                case .success:
                    break
                case .failure(_):
                    TipView.showWarn(ZGLocalizedString("toast_room_failed_to_operate"))
                }
            }
        }
        
        inviteAlter.addAction(cancelAction)
        inviteAlter.addAction(okAction)
        self.present(inviteAlter, animated: true, completion: nil)
    }
    
    private func logout() {
        RoomManager.shared.userService.logout()
        guard let nav = self.navigationController else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        for vc in nav.children {
            if vc is LoginVC {
                self.navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
}
