//
//  MoreCollectionViewCell.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/7.
//

import UIKit

class MoreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        roundView.layer.masksToBounds = true
        roundView.layer.cornerRadius = 22
    }
    
    func updateCell(_ model: MoreSettingModel) {
        iconImageView.image = UIImage.init(named: model.imageName ?? "")
        nameLabel.text = model.title
    }

}
