//
//  LiveReadyView.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import UIKit

enum LiveReadyAction {
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
            roomTitleTextField.layer.cornerRadius = 30.0
            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 60))
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 60))
            roomTitleTextField.leftView = leftView
            roomTitleTextField.leftViewMode = .always
            roomTitleTextField.rightView = rightView
            roomTitleTextField.rightViewMode = .always
            
            let attributed: [NSAttributedString.Key: Any] = [.foregroundColor: ZegoColor("FFFFFF_60")]
            let attributedStr = NSAttributedString(string: "Please enter the room name", attributes: attributed)
            roomTitleTextField.attributedPlaceholder = attributedStr
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
    
    
    
}
