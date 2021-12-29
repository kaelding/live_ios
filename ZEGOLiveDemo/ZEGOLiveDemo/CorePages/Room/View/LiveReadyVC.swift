//
//  LiveReadyVC.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import UIKit

protocol LiveReadyProtocol : AnyObject {
    
}

class LiveReadyVC: UIViewController {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    // MARK: - Action
    @IBAction func roomTitleTextFieldDidChanged(_ sender: UITextField) {
        
    }
    
    @IBAction func startLiveButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func beautyButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func settingButtonClick(_ sender: UIButton) {
        
    }
}
