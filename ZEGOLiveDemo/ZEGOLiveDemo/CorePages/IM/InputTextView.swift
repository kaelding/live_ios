//
//  InputTextView.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by zego on 2021/12/16.
//

import UIKit

protocol InputTextViewDelegate: AnyObject {
    func inputTextViewDidClickSend(_ message: String?)
}

class InputTextView: UIView, UITextFieldDelegate {

    weak var delegate: InputTextViewDelegate?
    
    @IBOutlet weak var inputTextView: UITextField!
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.isEnabled = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: w, height: h), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 12, height: 12))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    public func textViewBecomeFirstResponse() -> Void {
        inputTextView.becomeFirstResponder()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        var textStr : String = sender.text! as String
        let startIndex = textStr.index(textStr.startIndex, offsetBy: 0)
        if textStr.count > 100 {
            let index = textStr.index(textStr.startIndex, offsetBy: 100)
            textStr = String(textStr[startIndex...index])
        }
        sender.text = textStr
        
        sendButton.isEnabled = textStr.count > 0
    }
    
    @IBAction func sendButtonClick(_ sender: UIButton) {
        if (inputTextView.text?.count ?? 0) > 0 {
            if delegate != nil {
                delegate?.inputTextViewDidClickSend(inputTextView.text)
            }
            inputTextView.endEditing(true)
            inputTextView.text = ""
            sendButton.isEnabled = false
        }
    }

}
