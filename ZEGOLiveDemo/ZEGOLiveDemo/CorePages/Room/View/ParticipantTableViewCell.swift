//
//  ParticipantTableViewCell.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2022/1/5.
//

import UIKit

protocol ParticipantTableViewCellDelegate: AnyObject {
    func ParticipantTableViewCellDidSelectedMoreAction(cell: ParticipantTableViewCell)
}

class ParticipantTableViewCell: UITableViewCell {
    
    weak var delegate: ParticipantTableViewCellDelegate?

    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var roleLabel: UILabel!
    
    var userInfo: UserInfo?
    var selfIsHost: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
    }
    
    public func setRoomUser(user: UserInfo, isHost: Bool) -> Void {
        userInfo = user
        nameLabel.text = user.userName
        selfIsHost = isHost
        let imageName:String = String.getHeadImageName(userName: user.userName ?? "")
        avatarImage.image = UIImage(named: imageName)
        updateRoleInfo()
    }
    
    @IBAction func pressMoreButton(_ sender: UIButton) {
        delegate?.ParticipantTableViewCellDidSelectedMoreAction(cell: self)
    }
    
    func updateRoleInfo() -> Void {
        moreButton.isHidden = true
        roleLabel.isHidden = true
        guard let userInfo = userInfo else {  return }
        switch userInfo.role {
        case .participant:
            moreButton.isHidden = !selfIsHost
            roleLabel.isHidden = true
            break
        case .coHost:
            roleLabel.isHidden = false
            roleLabel.text =  "co-host";
            break
        case .host:
            roleLabel.isHidden = false
            roleLabel.text = "host";
            break
        case .invited:
            roleLabel.isHidden = false
            roleLabel.text = "invited";
            break
        }
    }
    
}
