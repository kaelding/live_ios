//
//  MusicEffectsModel.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/4.
//

import UIKit

class MusicEffectsModel: NSObject {
    
    var name: String?
    var imageName: String?
    var selectedImageName: String?
    var selectedType: UInt = 0
    var path: String?
    var isSelected: Bool = false
    
    init(json: Dictionary<String, Any>) {
        if let name = json["name"] as? String {
            self.name = name
        }
        if let imageName = json["imageName"] as? String {
            self.imageName = imageName
        }
        if let selectedImageName = json["selectedImageName"] as? String {
            self.selectedImageName = selectedImageName
        }
        if let selectedType = json["selectedType"] as? UInt {
            self.selectedType = selectedType
        }
        
        if let isSelected = json["isSelected"] as? Bool {
            self.isSelected = isSelected
        }
        
        if let path = json["path"] as? String {
            self.path = path
        }
    }

}
