//
//  LiveRoomVC+Ready.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation
import ZegoExpressEngine
import AVFoundation

extension LiveRoomVC : LiveReadyViewDelegate {
    func liveReadyView(_ readyView: LiveReadyView, didClickButtonWith action: LiveReadyAction) {
        switch action {
        case .back:
            self.navigationController?.popViewController(animated: true)
            break
        case .cameraFlip:
            isFrontCamera = !isFrontCamera
            ZegoExpressEngine.shared().useFrontCamera(isFrontCamera)
            break
        case .start:
            pressCreateButton()
        case .beauty:
            self.faceBeautifyView.isHidden = !self.faceBeautifyView.isHidden
        case .setting:
            self.liveSettingView?.isHidden = false
            print("liveReadyView did click button: \(action)")
        }
    }
    
    func pressCreateButton() {
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
            message = ZGLocalizedString("toast_room_name_error")
        }
        if message.count > 0 {
            HUDHelper .showMessage(message: message)
            return
        }
        
        HUDHelper.showNetworkLoading()
        
        RoomManager.shared.roomListService.createRoom(roomName) { result in
            switch result {
            case .success(let roomInfo):
                guard let roomID = roomInfo.roomID else { return }
                guard let roomName = roomInfo.roomName else { return }
                
                self.createRTCRoomWith(roomID: roomID, roomName: roomName)
                self.isLiving = true
            case .failure(let error):
                let message = String(format: ZGLocalizedString("toast_create_room_fail"), error.code)
                HUDHelper.showMessage(message: message)
            }
        }
    }
    
    func createRTCRoomWith(roomID: String, roomName: String) {
        
        let rtcToken = AppToken.getRtcToken(withRoomID: roomID) ?? ""
        RoomManager.shared.roomService.createRoom(roomID, roomName, rtcToken) { [self] result in
            HUDHelper.hideNetworkLoading()
            switch result {
            case .success():
                self.joinServerRoom()
                self.updateStartView()
                self.startPublish()
                self.updateTopView()
                break
            case .failure(let error):
                let message = String(format: ZGLocalizedString("toast_create_room_fail"), error.code)
                HUDHelper.showMessage(message: message)
                break
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
