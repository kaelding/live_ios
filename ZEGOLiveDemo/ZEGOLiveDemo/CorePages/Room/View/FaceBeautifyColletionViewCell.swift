//
//  FaceBeautifyColletionViewCell.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import UIKit

class FaceBeautifyColletionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var faceBeautifyModel: FaceBeautifyModel?
    
    func updateCellWithModel(_ model: FaceBeautifyModel) {
        faceBeautifyModel = model
        iconImage.image = UIImage(named: model.imageName)
        nameLabel.text = model.name
    }
}
