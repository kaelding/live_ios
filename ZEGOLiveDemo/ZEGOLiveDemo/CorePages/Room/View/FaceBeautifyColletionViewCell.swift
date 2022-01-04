//
//  FaceBeautifyColletionViewCell.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import UIKit

class FaceBeautifyColletionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImage: UIImageView! {
        didSet {
            iconImage.layer.cornerRadius = 22
            iconImage.layer.borderColor = ZegoColor("A653FF").cgColor
            iconImage.layer.borderWidth = 0
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    var faceBeautifyModel: FaceBeautifyModel?
    override var isSelected: Bool {
        willSet {
            iconImage.layer.borderWidth = newValue ? 2 : 0
        }
    }
    
    func updateCellWithModel(_ model: FaceBeautifyModel) {
        faceBeautifyModel = model
        iconImage.image = UIImage(named: model.imageName)
        nameLabel.text = model.name
    }
}
