//
//  LiveRoomVC+Participant.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2022/1/7.
//

import Foundation
import ZIM

extension LiveRoomVC: ParticipantListViewDelegate {
    func invitedUserAddCoHost(userInfo: UserInfo) {
        guard let userID = userInfo.userID else { return }
        RoomManager.shared.userService.addCoHost(userID, callback: { result in
            switch result {
            case .success:
                self.participantListView.inviteMaskView.isHidden = true
                self.participantListView.isHidden = true
                self.participantListView.reloadListView()
                TipView.showTip(ZGLocalizedString("room_page_invitation_has_sent"))
                self.restoreInvitedUserStatus(userInfo)
                break
            case .failure(let error):
                TipView.showWarn(String(error.code))
                break
            }
        })
    }
    
    // MARK: private method
    func restoreInvitedUserStatus(_ userInfo: UserInfo) {
        guard let userID = userInfo.userID else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 60000) {
            
            if let userInfo = RoomManager.shared.userService.userList.getObj(userID) {
                userInfo.hasInvited = false
            }
        }
    }
}

extension LiveRoomVC: UserServiceDelegate {
    func connectionStateChanged(_ state: ZIMConnectionState, _ event: ZIMConnectionEvent) {
        
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
        participantListView.reloadListView()
        updateTopView()
        updateBottomView()
    }
    
    func roomUserLeave(_ users: [UserInfo]) {
        
        for user in users {
            if user.userID == localUserID { continue }
            let model: MessageModel = MessageModelBuilder.buildLeftMessageModel(user: user)
            messageList.append(model)
        }
        
        reloadMessageData()
        participantListView.reloadListView()
        updateTopView()
    }
    
    func receiveAddCoHostInvitation() {
        let title = ZGLocalizedString("dialog_invition_title")
        let message = ZGLocalizedString("dialog_invition_descrip")
        let inviteAlter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_disagree"), style: .cancel) { action in
            RoomManager.shared.userService.respondCoHostInvitation(false, callback: nil)
        }
        let okAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_agree"), style: .default) { action in
            
            if RoomManager.shared.userService.coHostList.count > 4 {
                TipView.showWarn(ZGLocalizedString("room_page_no_more_seat_available"))
                return
            }
            
            RoomManager.shared.userService.takeCoHostSeat { result in
                switch result {
                case .success:
                    RoomManager.shared.userService.respondCoHostInvitation(true, callback: nil)
                    break
                case .failure(let error):
                    RoomManager.shared.userService.respondCoHostInvitation(false, callback: nil)
                    let message = String(format: ZGLocalizedString("toast_to_be_a_speaker_seat_fail"), error.code)
                    TipView.showWarn(message)
                }
            }
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
        participantListView.reloadListView()
    }
    /// receive request to co-host request
    func receiveToCoHostRequest(_ userInfo: UserInfo) {
        guard let name = userInfo.userName else { return }
        guard let userID = userInfo.userID else { return }
        let title = ZGLocalizedString("dialog_room_page_title_connection_request")
        let message = String(format: ZGLocalizedString("dialog_room_page_message_connection_request"), name)
        let inviteAlter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_disagree"), style: .cancel) { action in
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
    /// receive cancel request to co-host
    func receiveCancelToCoHostRequest(_ userInfo: UserInfo) {
        guard let name = userInfo.userName else { return }
        let message = String(format: ZGLocalizedString("toast_room_has_canceled_connection_apply"), name)
        TipView.showTip(message)
        
        if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    /// receive response to request to co-host
    func receiveToCoHostRespond(_ agree: Bool) {
        TipView.dismiss()
        if agree {
            if RoomManager.shared.userService.coHostList.count >= 4 {
                TipView.showWarn("toast_room_maximum")
                return
            }
            RoomManager.shared.userService.takeCoHostSeat { result in
                if result.isSuccess {
                    self.updateBottomView()
                }
            }
        } else {
            TipView.showWarn("toast_room_has_rejected")
        }
        bottomView?.resetApplyStatus()
    }
    
    func coHostChange(_ targetUserID: String, type: CoHostChangeType) {
        reloadCoHost()
        updateBottomView()
        updateHostBackgroundView()
        participantListView.reloadListView()
        
        // be removed by host
        if type == .remove && isUserMyself(targetUserID) {
            TipView.showTip(ZGLocalizedString("toast_room_prohibited_connection"))
        }
        
        if isMyselfHost && type == .leave && !isUserMyself(targetUserID) {
            if let user = getUser(targetUserID) {
                TipView.showWarn(String(format: ZGLocalizedString("toast_room_ended_the_connection"), user.userName ?? ""))
            }
        }
        
        guard let coHost = getCoHost(targetUserID) else { return }
        if coHost.isMuted && type == .mute && isUserMyself(coHost.userID) {
            TipView.showTip(ZGLocalizedString("toast_room_muted_by_host"))
        }
    }
}
