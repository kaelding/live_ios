//
//  LiveRoomVC+Ready.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation

extension LiveRoomVC : LiveReadyViewDelegate {
    func liveReadyView(_ readyView: LiveReadyView, didClickButtonWith action: LiveReadyAction) {
        switch action {
        case .back:
            self.navigationController?.popViewController(animated: true)
            break
        case .cameraFlip:
            isFrontCamera = !isFrontCamera
            RoomManager.shared.deviceService.useFrontCamera(isFrontCamera)
            break
        case .start:
            pressCreateButton()
        case .beauty:
            self.faceBeautifyView.isHidden = !self.faceBeautifyView.isHidden
        case .setting:
            self.liveSettingView?.isHidden = false
        }
    }
    
    func pressCreateButton() {
        if !AuthorizedCheck.isCameraAuthorized() {
            AuthorizedCheck.showCameraUnauthorizedAlert(self)
            return
        }
        if !AuthorizedCheck.isMicrophoneAuthorized() {
            AuthorizedCheck.showMicrophoneUnauthorizedAlert(self)
            return
        }
        guard let name = self.readyView?.roomTitleTextField.text else { return }
        createRoomWithRoomName(roomName: name)
     }
    
    // MARK: private method
    @objc func createRoomNameTextFieldDidChange(textField:UITextField) -> Void {
        let text:String = textField.text! as String
        if text.count > 16 {
            let startIndex = text.index(text.startIndex, offsetBy: 0)
            let index = text.index(text.startIndex, offsetBy: 15)
            textField.text = String(text[startIndex...index])
        }
    }
    
    func createRoomWithRoomName(roomName: String) -> Void {
        var message:String = ""
        if roomName.count == 0 {
            message = ZGLocalizedString("create_page_room_name")
        }
        if message.count > 0 {
            TipView.showWarn(message)
            return
        }
        
        HUDHelper.showNetworkLoading()
        
        RoomManager.shared.roomListService.createRoom(roomName) { result in
            switch result {
            case .success(let roomInfo):
                guard let roomID = roomInfo.roomID else { return }
                guard let roomName = roomInfo.roomName else { return }
                
                self.createRTCRoomWith(roomID: roomID, roomName: roomName)
            case .failure(let error):
                let message = String(format: ZGLocalizedString("toast_create_room_fail"), error.code)
                TipView.showWarn(message)
            }
        }
    }
    
    func createRTCRoomWith(roomID: String, roomName: String) {
        guard let userID = RoomManager.shared.userService.localUserInfo?.userID else { return }
        TokenManager.shared.getToken(userID) { result in
            if result.isSuccess {
                let rtcToken: String? = result.success
                guard let rtcToken = rtcToken else {
                    print("token is nil")
                    HUDHelper.hideNetworkLoading()
                    return
                }
                RoomManager.shared.roomService.createRoom(roomID, roomName, rtcToken) { [self] result in
                    HUDHelper.hideNetworkLoading()
                    self.addDelegates()
                    switch result {
                    case .success():
                        self.isLiving = true
                        self.joinServerRoom()
                        self.updateStartView()
                        self.updateTopView()
                        self.addLocalJoinMessage()
                        RoomManager.shared.userService.takeSeat { result in
                            
                        }
                        break
                    case .failure(let error):
                        let message = String(format: ZGLocalizedString("toast_create_room_fail"), error.code)
                        TipView.showWarn(message)
                        break
                    }
                }
            } else {
                HUDHelper.showMessage(message: "get token fail")
            }
        }
    }
    
    func updateStartView() {
        self.readyContainer.isHidden = true
        self.topContainer.isHidden = false
        self.bottomContainer.isHidden = false
        self.messageView.isHidden = false
        self.coHostCollectionView.isHidden = true
    }
    
    func joinServerRoom() {
        if let roomID = RoomManager.shared.roomService.roomInfo.roomID {
            RoomManager.shared.roomListService.joinServerRoom(roomID) { result in
            }
        }
    }
}
