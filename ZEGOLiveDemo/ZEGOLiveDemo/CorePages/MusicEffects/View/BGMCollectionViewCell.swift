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
    @IBOutlet weak var musicStatusImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundRectView.layer.masksToBounds = true
        roundRectView.layer.cornerRadius = 8.0
    }

}
