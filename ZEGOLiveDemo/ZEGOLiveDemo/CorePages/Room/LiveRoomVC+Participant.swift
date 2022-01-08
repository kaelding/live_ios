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
                userInfo.role = .invited
                self.participantListView.reloadListView()
                HUDHelper.showMessage(message:ZGLocalizedString("room_page_invitation_has_sent"))
                self.restoreInvitedUserStatus(userInfo)
                break
            case .failure(let error):
                HUDHelper.showMessage(message:"\(error.code)")
                break
            }
        })
    }
    
    // MARK: private method
    func restoreInvitedUserStatus(_ userInfo: UserInfo) {
        guard let userID = userInfo.userID else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 60000) {
            
            if let userInfo = RoomManager.shared.userService.userList.getObj(userID) {
                if userInfo.role == .invited {
                    userInfo.role = .participant
                }
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
        
        bottomView?.updateUI(type: getBottomUIType())
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
        
        let cancelAction = UIAlertAction(title: ZGLocalizedString("dialog_refuse"), style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: ZGLocalizedString("dialog_accept"), style: .default) { action in
            
            if RoomManager.shared.userService.coHostList.count > 4 {
                HUDHelper.showMessage(message: ZGLocalizedString("room_page_no_more_seat_available"))
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
                    HUDHelper.showMessage(message: message)
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
        if user.role == .invited {
            user.role = .participant
        }
    }
    /// receive request to co-host request
    func receiveToCoHostRequest(_ userInfo: UserInfo) {
        guard let name = userInfo.userName else { return }
        guard let userID = userInfo.userID else { return }
        let title = ZGLocalizedString("Connection request!")
        let message = name + ZGLocalizedString(" is requesting a connection with you. Do you agree?")
        let inviteAlter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: ZGLocalizedString("dialog_refuse"), style: .cancel) { action in
            RoomManager.shared.userService.respondCoHostRequest(false, userID) { result in
                switch result {
                case .success:
                    let message = String(format: ZGLocalizedString("rejected request success"))
                    HUDHelper.showMessage(message: message)
                    break
                case .failure(let error):
                    let message = String(format: ZGLocalizedString("rejected request fail"), error.code)
                    HUDHelper.showMessage(message: message)
                }
            }
        }
        let okAction = UIAlertAction(title: ZGLocalizedString("dialog_accept"), style: .default) { action in
            
            RoomManager.shared.userService.respondCoHostRequest(true, userID) { result in
                switch result {
                case .success:
                    let message = String(format: ZGLocalizedString("access request success"))
                    HUDHelper.showMessage(message: message)
                    break
                case .failure(let error):
                    let message = String(format: ZGLocalizedString("access request fail"), error.code)
                    HUDHelper.showMessage(message: message)
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
        let message = name + String(format: ZGLocalizedString("has cancel coHost request"))
        HUDHelper.showMessage(message: message)
        if self.presentedViewController != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    /// receive response to request to co-host
    func receiveToCoHostRespond(_ agree: Bool) {
        if agree {
            if RoomManager.shared.userService.coHostList.count >= 4 {
                TipView.showWarn("A maximum of 3 viewers can connect with the host！")
                return
            }
            RoomManager.shared.userService.takeCoHostSeat { result in
                if result.isSuccess {
                    self.bottomView?.updateUI(type: .coHost)
                }
            }
        } else {
            TipView.showWarn("Host has rejected your request！")
        }
        bottomView?.resetApplyStatus()
    }
    
    func coHostChange(_ coHost: CoHostSeatModel?, type: CoHostChangeType) {
        reloadCoHost()
    }
}
