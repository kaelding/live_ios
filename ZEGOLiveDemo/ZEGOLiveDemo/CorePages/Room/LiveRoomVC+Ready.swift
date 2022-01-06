//
//  LiveRoomVC+Ready.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation
import ZegoExpressEngine

extension LiveRoomVC : LiveReadyViewDelegate {
    func liveReadyView(_ readyView: LiveReadyView, didClickButtonWith action: LiveReadyAction) {
        switch action {
        case .start:
            pressCreateButton()
        case .beauty:
            self.faceBeautifyView.isHidden = !self.faceBeautifyView.isHidden
        case .setting:
            print("liveReadyView did click button: \(action)")
        }
    }
    
    func pressCreateButton() {
         let alter:UIAlertController = UIAlertController.init(title: ZGLocalizedString("create_page_create_room"), message: "", preferredStyle: UIAlertController.Style.alert)
         let cancelAction:UIAlertAction = UIAlertAction.init(title: ZGLocalizedString("create_page_cancel"), style: UIAlertAction.Style.cancel, handler: nil)
         let createAction:UIAlertAction = UIAlertAction.init(title: ZGLocalizedString("create_page_create"), style: UIAlertAction.Style.default) { action in
             let roomNameTextField = (alter.textFields?.last)!
             self.createRoomWithRoomName( roomName: roomNameTextField.text! as String)
         }
         alter.addTextField { textField in
             textField.placeholder = ZGLocalizedString("create_page_room_name")
             textField.font = UIFont.systemFont(ofSize: 14)
             textField.addTarget(self, action: #selector(self.createRoomNameTextFieldDidChange), for: UIControl.Event.editingChanged)
         }
         alter.addAction(cancelAction)
         alter.addAction(createAction)
         self.present(alter, animated: true, completion: nil)
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
            case .failure(let error):
                let message = String(format: ZGLocalizedString("toast_create_room_fail"), error.code)
                HUDHelper.showMessage(message: message)
            }
        }
    }
    
    func createRTCRoomWith(roomID: String, roomName: String) {
        
        let rtcToken = AppToken.getRtcToken(withRoomID: roomID) ?? ""
        RoomManager.shared.roomService.createRoom(roomID, roomName, rtcToken) { result in
            HUDHelper.hideNetworkLoading()
            switch result {
            case .success(let roomInfo):
                break
            case .failure(let error):
                let message = String(format: ZGLocalizedString("toast_create_room_fail"), error.code)
                HUDHelper.showMessage(message: message)
            }
        }
    }
}
