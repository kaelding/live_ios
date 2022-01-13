//
//  LiveReadyView.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import UIKit

enum LiveReadyAction {
    case back
    case cameraFlip
    case start
    case beauty
    case setting
}

protocol LiveReadyViewDelegate : AnyObject {
    func liveReadyView(_ readyView: LiveReadyView, didClickButtonWith action: LiveReadyAction)
}

class LiveReadyView: UIView {

    weak var delegate: LiveReadyViewDelegate?
    
    @IBOutlet weak var roomTitleTextField: UITextField! {
        didSet {
            roomTitleTextField.delegate = self
            roomTitleTextField.layer.cornerRadius = 30.0
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 60))
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 60))
            roomTitleTextField.leftView = leftView
            roomTitleTextField.leftViewMode = .always
            roomTitleTextField.rightView = rightView
            roomTitleTextField.rightViewMode = .always
            
            let attributed: [NSAttributedString.Key: Any] = [.foregroundColor: ZegoColor("FFFFFF_60")]
            let attributedStr = NSAttributedString(string: ZGLocalizedString("create_page_room_name"), attributes: attributed)
            roomTitleTextField.attributedPlaceholder = attributedStr
            roomTitleTextField.placeholder = ZGLocalizedString("create_page_room_name")
        }
    }
    @IBOutlet weak var startLiveButton: UIButton! {
        didSet {
            startLiveButton.layer.cornerRadius = 22
            let layer = CAGradientLayer()
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
            layer.locations = [NSNumber(value: 0.5), NSNumber(value: 1.0)]
            let startColor = ZegoColor("A754FF")
            let endColor = ZegoColor("510DF1")
            layer.colors = [startColor.cgColor, endColor.cgColor]
            layer.frame = startLiveButton.bounds
            startLiveButton.layer.addSublayer(layer)
            startLiveButton.layer.cornerRadius = 22.0
            startLiveButton.setTitle(ZGLocalizedString(ZGLocalizedString("create_page_room_start")), for: .normal)
        }
    }
    
    @IBOutlet weak var beautyButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    var roomTitle: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Action
    @IBAction func roomTitleTextFieldDidChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        roomTitle = text
    }
    
    @IBAction func startLiveButtonClick(_ sender: UIButton) {
        delegate?.liveReadyView(self, didClickButtonWith: .start)
    }
    
    @IBAction func beautyButtonClick(_ sender: UIButton) {
        delegate?.liveReadyView(self, didClickButtonWith: .beauty)
    }
    
    @IBAction func settingButtonClick(_ sender: UIButton) {
        delegate?.liveReadyView(self, didClickButtonWith: .setting)
    }
    
    @IBAction func backButtonClick(_ sender: UIButton) {
        delegate?.liveReadyView(self, didClickButtonWith: .back)
    }
    
    @IBAction func cameraFlipButtonClick(_ sender: UIButton) {
        delegate?.liveReadyView(self, didClickButtonWith: .cameraFlip)
    }
    
}

extension LiveReadyView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let proposeLength = (textField.text?.lengthOfBytes(using: .utf8))! - range.length + string.lengthOfBytes(using: .utf8)
        if proposeLength > 32 {
            return false
        }
        return true
    }
}
