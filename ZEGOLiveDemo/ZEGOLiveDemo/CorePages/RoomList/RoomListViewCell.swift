//
//  RoomListViewCell.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/28.
//

import UIKit

class RoomListViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroudImage: UIImageView!
    
    @IBOutlet weak var participantNumLabel: UILabel!
    
    @IBOutlet weak var roomNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 12.0
    }
}
