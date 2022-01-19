//
//  FaceBeautifyColletionViewCell.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import UIKit

class FaceBeautifyColletionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconBackView: UIView! {
        didSet {
            iconBackView.layer.cornerRadius = 22
            iconBackView.layer.borderColor = ZegoColor("A653FF").cgColor
            iconBackView.layer.borderWidth = 0
        }
    }
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var faceBeautifyModel: FaceBeautifyModel?
    override var isSelected: Bool {
        willSet {
            iconBackView.layer.borderWidth = newValue ? 2 : 0
        }
    }
    
    func updateCellWithModel(_ model: FaceBeautifyModel) {
        faceBeautifyModel = model
        iconImage.image = UIImage(named: model.imageName)
        nameLabel.text = ZGLocalizedString(model.name)
    }
}
