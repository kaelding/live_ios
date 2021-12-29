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
    case flip
    case camera
    case mic
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
        delegate?.liveBottomView(self, didClickButtonWith: .camera)
    }
    
    @IBAction func micButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .mic)
    }
    
    @IBAction func endButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .end)
    }
    
    @IBAction func applyButtonClick(_ sender: UIButton) {
        delegate?.liveBottomView(self, didClickButtonWith: .apply)
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