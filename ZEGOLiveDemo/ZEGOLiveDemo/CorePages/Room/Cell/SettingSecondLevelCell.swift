//
//  SettingSecondLevelCell.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/6.
//

import UIKit

protocol SettingSecondLevelCellDelegate {
    func settingSecondLevelCellSelectedClick(_ isSelected: Bool, cell: SettingSecondLevelCell)
}

class SettingSecondLevelCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedButton: UIButton!
    
    var delegate: SettingSecondLevelCellDelegate?
    var cellModel: LiveSettingSecondLevelModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }
    
    @IBAction func selectedClick(_ sender: UIButton) {
        if let cellModel = cellModel {
            if !cellModel.isSelected {
                delegate?.settingSecondLevelCellSelectedClick(!cellModel.isSelected, cell: self)
            }
        }
    }
    
    func updateCell(_ model: LiveSettingSecondLevelModel) -> Void {
        cellModel = model
        titleLabel.text = model.title
        titleLabel.textColor = model.isSelected ? UIColor.white : ZegoColor("CCCCCC")
    }
    
}
