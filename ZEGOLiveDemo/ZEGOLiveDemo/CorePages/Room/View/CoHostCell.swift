//
//  CoHostCell.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2022/1/6.
//

import UIKit

protocol CoHostCellDelegate: AnyObject {
    func moreButtonClick(_ cell: CoHostCell)
}

class CoHostCell: UICollectionViewCell {

    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
//            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
//            visualEffectView.frame = backgroundImageView.bounds
//            backgroundImageView.addSubview(visualEffectView)
        }
    }
    
    @IBOutlet weak var headImageView: UIImageView! {
        didSet {
            headImageView.layer.cornerRadius = 27.0
        }
    }
    @IBOutlet weak var streamView: UIView!
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.layer.cornerRadius = 7.0
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var micOffImageView: UIImageView!
    
    var model: CoHostSeatModel? {
        didSet {
            self.backView.isHidden = model?.camera ?? false
            self.micOffImageView.isHidden = model?.mic ?? false
            let user = getUser(model?.userID)
            nameLabel.text = user?.userName
            setAvatar(String.getHeadImageName(userName: user?.userName ?? ""))
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 8.0
        setAvatar("liveShow_KTV")
    }
    
    weak var delegate: CoHostCellDelegate?
    
    @IBAction func moreButtonClick(_ sender: UIButton) {
        delegate?.moreButtonClick(self)
    }
        
    private func setAvatar(_ imageName: String?) {
        guard let imageName = imageName else { return }
        guard let image = UIImage(named: imageName) else { return }
        guard let ciimage = CIImage(image: image) else { return }
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(ciimage, forKey: kCIInputImageKey)
        filter?.setValue(10, forKey: kCIInputRadiusKey)
        let context = CIContext(options: nil)
        guard let result = filter?.outputImage else { return }
        let rect = CGRect(x: 0,
                          y: 0,
                          width: result.extent.width + result.extent.origin.x * 2,
                          height: result.extent.height + result.extent.origin.y * 2)
        guard let cgimage = context.createCGImage(result, from: rect) else { return }
        backgroundImageView.image = UIImage(cgImage: cgimage)
        headImageView.image = UIImage(named: imageName)
    }
    
    private func getUser(_ userID: String?) -> UserInfo? {
        guard let userID = userID else {
            return nil
        }
        for user in RoomManager.shared.userService.userList.allObjects() {
            if user.userID == userID {
                return user
            }
        }
        return nil
    }
}
