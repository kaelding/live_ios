//
//  MoreSettingModel.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/7.
//

import UIKit

enum selectedType: Int {
    case flip
    case camera
    case mute
    case data
    case setting
}

class MoreSettingModel: NSObject {

    var imageName: String?
    var title: String?
    var type: selectedType = .flip
    var isSelected: Bool = false
    
    init(json: Dictionary<String, Any>) {
        if let imageName = json["imageName"] as? String {
            self.imageName = imageName
        }
        if let title = json["title"] as? String {
            self.title = title
        }
        if let type = json["type"] as? selectedType {
            self.type = type
        }
        if let isSelected = json["isSelected"] as? Bool {
            self.isSelected = isSelected
        }
    }
}
