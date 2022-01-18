//
//  SettingSwitchCell.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/5.
//

import UIKit

protocol SettingSwitchCellDelegate: AnyObject {
    func cellSwitchValueChange(_ value: Bool, cell: SettingSwitchCell)
}

class SettingSwitchCell: SettingBaseCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    weak var delegate: SettingSwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func updateCell(_ model: LiveSettingModel) {
        super.updateCell(model)
        cellModel = model
        titleLabel.text = model.title
        switchButton.isOn = model.switchStatus
        if model.selectionType == .layeredCoding {
            if RoomManager.shared.deviceService.codec == .h265 {
                switchButton.isEnabled = false
                titleLabel.textColor = ZegoColor("FFFFFF_50")
            } else {
                switchButton.isEnabled = true
                titleLabel.textColor = ZegoColor("FFFFFF")
            }
        } else {
            switchButton.isEnabled = true
            titleLabel.textColor = ZegoColor("FFFFFF")
        }
    }
    
    @IBAction func switchValueChange(_ sender: UISwitch) {
        delegate?.cellSwitchValueChange(sender.isOn , cell: self)
    }
}
