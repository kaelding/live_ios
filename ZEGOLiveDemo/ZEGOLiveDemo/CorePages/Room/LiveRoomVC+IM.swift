//
//  LiveRoomVC+IM.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2022/1/4.
//

import Foundation

extension LiveRoomVC {
    // MARK: - Notification
    @objc func keyBoardDidShow(node : Notification){
        if !self.readyContainer.isHidden { return }
        guard let userInfo = node.userInfo else { return }
        guard let keyboardValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardRect: CGRect = keyboardValue.cgRectValue
        
        guard let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
        let duration: Double = durationValue.doubleValue
        
        UIView.animate(withDuration: duration) {
            self.inputTextView.frame = CGRect(x: 0,
                                           y: UIScreen.main.bounds.size.height - keyboardRect.size.height - 55,
                                           width: self.view.bounds.size.width,
                                           height: 55)
        }
    }
    
    @objc func keyBoardDidHide(node : Notification){
        UIView.animate(withDuration: 0.25) {
            self.inputTextView.frame = CGRect(x: 0,
                                           y: UIScreen.main.bounds.size.height,
                                           width: self.view.bounds.size.width,
                                           height: 55)
        }
    }
 
    func reloadMessageData() -> Void {
        updateMessageHeightConstraint()
        messageView.reloadWithData(data: messageList)
        messageView.scrollToBottom()
    }
    
    func updateMessageHeightConstraint() -> Void {
        var height: CGFloat = 0
        for model: MessageModel in messageList {
            height += (model.messageHeight ?? 0) + 4.0 + 10.0
        }
        messageHeightConstraint.constant = height
    }

}

extension LiveRoomVC : InputTextViewDelegate {
    //MARK: -InputTextViewDelegate
    func inputTextViewDidClickSend(_ message: String?) {
        guard let message = message else  { return }
        if message.count == 0 { return }
        RoomManager.shared.messageService.sendTextMessage(message) { result in
            switch result {
            case .success(()):
                let model = MessageModelBuilder.buildModel(with: self.getUser(self.localUserID), message: message)
                self.messageList.append(model)
                self.reloadMessageData()
            case .failure(let error):
                let message = String(format: ZGLocalizedString("toast_send_message_error"), error.code)
                HUDHelper.showMessage(message: message)
            }
        }
    }
}

extension LiveRoomVC : MessageServiceDelegate {
    func receiveTextMessage(_ message: TextMessage) {
        let model = MessageModelBuilder.buildModel(with: getUser(localUserID), message: message.message)
        messageList.append(model)
        reloadMessageData()
    }
}
