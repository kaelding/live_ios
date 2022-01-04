//
//  LiveRoomVC.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/28.
//

import UIKit

class LiveRoomVC: UIViewController {

    @IBOutlet weak var streamView: UIView!
    
    var readyView: LiveReadyView?
    @IBOutlet weak var readyContainer: UIView! {
        didSet {
            if let readyView = UINib(nibName: "LiveReadyView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LiveReadyView {
                readyView.frame = readyContainer.bounds
                readyContainer.addSubview(readyView)
                self.readyView = readyView
                readyView.delegate = self
            }
        }
    }
    
    var bottomView: LiveBottomView?
    @IBOutlet weak var bottomContainer: UIView! {
        didSet {
            bottomContainer?.backgroundColor = UIColor.clear
            if let bottomView = UINib(nibName: "LiveBottomView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LiveBottomView {
                bottomView.frame = bottomContainer.bounds
                bottomContainer.addSubview(bottomView)
                self.bottomView = bottomView
                bottomView.delegate = self
            }
        }
    }
    
    var topView: LiveTopView?
    @IBOutlet weak var topContainer: UIView! {
        didSet {
            topContainer.backgroundColor = UIColor.clear
            if let topView = UINib(nibName: "LiveTopView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LiveTopView {
                topView.frame = topContainer.bounds
                topContainer.addSubview(topView)
                self.topView = topView
                topView.delegate = self
            }
        }
    }
    
    var faceBeautifyView: FaceBeautifyView?
    @IBOutlet weak var beautifyContainer: UIView! {
        didSet {
            if let beautifyView = UINib(nibName: "FaceBeaytifyView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? FaceBeautifyView {
                beautifyView.frame = beautifyContainer.bounds
                beautifyContainer.addSubview(beautifyView)
                self.faceBeautifyView = beautifyView
                self.beautifyContainer.isHidden = true
            }
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    func configUI() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let window : UIWindow = UIApplication.shared.windows.first!
        window.endEditing(true)
    }

    // MARK: - Action
    @IBAction func backItemClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeCameraItemClick(_ sender: UIBarButtonItem) {
        
    }
    
    
}
