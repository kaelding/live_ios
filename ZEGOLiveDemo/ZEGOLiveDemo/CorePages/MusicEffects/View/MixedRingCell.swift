//
//  MixedRingCell.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2021/12/31.
//

import UIKit

class MixedRingCell: UICollectionViewCell {

    @IBOutlet weak var mixedImageView: UIImageView!
    @IBOutlet weak var mixedNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mixedImageView.layer.masksToBounds = true
        mixedImageView.layer.cornerRadius = 22.0
    }
    
    var mixModel: MusicEffectsModel?
    
    func updateCellWithModel(_ model: MusicEffectsModel) {
        mixModel = model
        mixedNameLabel.text = model.name
        mixedImageView.image = UIImage.init(named: model.imageName ?? "")
        
        self.mixedImageView.layer.borderWidth = model.isSelected ? 1.5 : 0;
        self.mixedImageView.layer.borderColor = ZegoColor("A653FF").cgColor
    }

}
