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
    
    lazy var faceBeautifyView: FaceBeautifyView = {
        let beautifyView = UINib(nibName: "FaceBeaytifyView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! FaceBeautifyView
        beautifyView.frame = self.view.bounds
        beautifyView.isHidden = true
        self.view.addSubview(beautifyView)
        return beautifyView
    }()
    
    lazy var musicEffectsVC : MusicEffectsVC = {
        let vc: MusicEffectsVC = MusicEffectsVC(nibName :"MusicEffectsVC",bundle : nil)
        vc.view.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        vc.view.isHidden = true
        self.addChild(vc)
        self.view.addSubview(vc.view)
        return vc
    }()
    
    lazy var liveSettingView : LiveSettingView? = {
        if let view: LiveSettingView = UINib.init(nibName: "LiveSettingView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LiveSettingView {
            view.frame = CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            view.isHidden = true
            self.view.addSubview(view)
            return view
        }
        return nil
    }()
    
    var participantListView: ParticipantListView {
        guard let participantListView = UINib(nibName: "ParticipantListView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? ParticipantListView else {
            return ParticipantListView()
        }
        participantListView.frame = self.view.bounds
        participantListView.isHidden = true
        self.view.addSubview(participantListView)
        return participantListView
    }
    
    @IBOutlet weak var messageView: MessageView!
    
    @IBOutlet weak var messageHeightConstraint: NSLayoutConstraint!
    
    var messageList: [MessageModel] = []
    
    lazy var inputTextView: InputTextView = {
        let textView: InputTextView = UINib(nibName: "InputTextView", bundle: nil).instantiate(withOwner: self, options: nil).last as! InputTextView
        textView.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.view.bounds.size.width, height: 55)
        textView.delegate = self
        return textView
    }()
    
    var localUserID: String {
        get {
            return RoomManager.shared.userService.localInfo?.userID ?? ""
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        RoomManager.shared.messageService.delegate = self
        addObserver()

        // Do any additional setup after loading the view.
        configUI()
        
        if let myself = RoomManager.shared.userService.localInfo {
            let model: MessageModel = MessageModelBuilder.buildJoinMessageModel(user: myself)
            messageList.append(model)
            reloadMessageData()
        }
    }
    
    func configUI() {
        self.view.addSubview(inputTextView)

        
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
    
    // MARK: - private method
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidShow(node:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDidHide(node:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}
