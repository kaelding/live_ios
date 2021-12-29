//
//  LiveRoomVC.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/28.
//

import UIKit

class LiveRoomVC: UIViewController {

    @IBOutlet weak var streamView: UIView!
    
    @IBOutlet weak var readyContainer: UIView! {
        didSet {
            readyVC.view.frame = readyContainer.bounds
            readyContainer.addSubview(readyVC.view)
        }
    }
    lazy var readyVC: LiveReadyVC = {
        let vc = LiveReadyVC(nibName: "LiveReadyVC", bundle: nil)
        return vc
    }()
    
    var bottomView: LiveBottomView?
    @IBOutlet weak var bottomContainer: UIView! {
        didSet {
            if let bottomView = UINib(nibName: "LiveBottomView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LiveBottomView {
                bottomView.frame = bottomContainer.bounds
                bottomContainer.addSubview(bottomView)
                self.bottomView = bottomView
                bottomView.delegate = self
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
