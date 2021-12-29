//
//  LiveTopView.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import UIKit

enum LiveTopAction {
    case participant
    case close
}

protocol LiveTopViewDelegate : AnyObject {
    func liveTopView(_ topView: LiveTopView, didClickButtonWith action: LiveTopAction)
}

class LiveTopView: UIView {

    weak var delegate: LiveTopViewDelegate?
    
    
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.layer.cornerRadius = 17.0
        }
    }
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = 14.0
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var participantButton: UIButton! {
        didSet {
            participantButton.layer.cornerRadius = 17.0
        }
    }
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.layer.cornerRadius = 13.0
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    // MARK: - action
    @IBAction func participantButtonClick(_ sender: UIButton) {
        delegate?.liveTopView(self, didClickButtonWith: .participant)
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        delegate?.liveTopView(self, didClickButtonWith: .close)
    }
    
}
