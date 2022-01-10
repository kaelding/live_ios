//
//  LiveBottomView.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/28.
//

import UIKit

enum LiveBottomUIType {
    case host
    case participant
    case coHost
}

enum LiveBottomAction {
    case message
    case share
    case beauty
    case soundEffect
    case more
    case apply
    case cancelApply
    case flip
    case camera(_ open: Bool)
    case mic(_ open: Bool)
    case end
}

protocol LiveBottomViewDelegate : AnyObject {
    func liveBottomView(_ bottomView: LiveBottomView, didClickButtonWith action: LiveBottomAction)
}

class LiveBottomView: UIView {
    
    weak var delegate: LiveBottomViewDelegate?
    
    @IBOutlet weak var messageButton: UIButton! {
        didSet {
            messageButton.layer.cornerRadius = 18.0
        }
    }
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.layer.cornerRadius = 18.0
        }
    }
    @IBOutlet weak var flipButton: UIButton! {
        didSet {
            flipButton.layer.cornerRadius = 18.0
        }
    }
    @IBOutlet weak var cameraButton: UIButton! {
        didSet {
            cameraButton.layer.cornerRadius = 18.0
        }
    }
    @IBOutlet weak var micButton: UIButton! {
        didSet {
            micButton.layer.cornerRadius = 18.0
        }
    }
    @IBOutlet weak var endButton: UIButton! {
        didSet {
            endButton.layer.cornerRadius = 18.0
        }
    }
    @IBOutlet weak var applyButton: UIButton! {
        didSet {
            applyButton.layer.cornerRadius = 18.0
            applyButton.setTitle(ZGLocalizedString("room_page_apply_to_connect"), for: .normal)
            applyButton.setTitle(ZGLocalizedString("room_page_apply_to_connect"), for: [.normal, .highlighted])
            applyButton.setTitle(ZGLocalizedString("room_page_cancel_to_connect"), for: .selected)
            applyButton.setTitle(ZGLocalizedString("room_page_cancel_to_connect"), for: [.selected, .highlighted])
        }
    }
    @IBOutlet weak var beautyButton: UIButton! {
        didSet {
            beautyButton.layer.cornerRadius = 18.0
        }
    }
    @IBOutlet weak var soundEffectButton: UIButton! {
        didSet {
            soundEffectButton.layer.cornerRadius = 18.0
        }
    }
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.layer.cornerRadius = 18.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateUI(type: .host)
    }

    func updateUI(type: LiveBottomUIType) {
        
        self.flipButton.isHidden = type != .coHost
        self.cameraButton.isHidden = type != .coHost
        self.micButton.isHidden = type != .coHost
        self.endButton.isHidden = type != .coHost
        
        self.applyButton.isHidden = type != .participant
        
        self.beautyButton.isHidden = type != .host
        self.soundEffectButton.isHidden = type != .host
        self.moreButton.isHidden = type != .host
    }
    
    func updateMicStatus(_ open: Bool) {
        micButton.isSelected = !open
    }
    
    func updateCameraStatus(_ open: Bool) {
        cameraButton.isSelected = !open
    }
    
    func resetApplyStatus() {
        applyButton.isSelected = false
    }
    
    // MARK: - actions
    @IBAction func messageButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .message)
    }
    
    @IBAction func shareButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .share)
    }
    
    @IBAction func flipButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .flip)
    }
    
    @IBAction func cameraButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.liveBottomView(self, didClickButtonWith: .camera(!sender.isSelected))
    }
    
    @IBAction func micButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.liveBottomView(self, didClickButtonWith: .mic(!sender.isSelected))
    }
    
    @IBAction func endButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .end)
    }
    
    @IBAction func applyButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let action: LiveBottomAction = sender.isSelected ? .apply : .cancelApply
        delegate?.liveBottomView(self, didClickButtonWith: action)
    }
    
    @IBAction func beautyButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .beauty)
    }
    
    @IBAction func soundEffectButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .soundEffect)
    }
    @IBAction func moreButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .more)
    }
}
