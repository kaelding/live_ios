//
//  BGMCollectionViewCell.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2021/12/31.
//

import UIKit

class BGMCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var roundRectView: UIView!
    @IBOutlet weak var musicImageView: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundRectView.layer.masksToBounds = true
        roundRectView.layer.cornerRadius = 8.0
    }
    
    var bgmModel: MusicEffectsModel?
    
    func updateCellWithModel(_ model: MusicEffectsModel) {
        bgmModel = model
        musicNameLabel.text = model.name
        if model.isSelected {
            musicImageView.image = UIImage.init(named: model.selectedImageName ?? "")
        } else {
            musicImageView.image = UIImage.init(named: model.imageName ?? "")
        }
        
        musicNameLabel.textColor = model.isSelected ? ZegoColor("A653FF") : ZegoColor("CCCCCC")
        
    }

}
