//
//  FaceBeautifyModel.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import UIKit

class FaceBeautifyModel: NSObject {
    
    var type: FaceBeautifyType = FaceBeautifyType.SkinToneEnhancement
    var value: Int = 0
    var imageName: String = "face_beautify_skin_tone_enhancement"
    var name: String = ZGLocalizedString("room_beautify_page_skin_tone_enhancement")
    
    init(json: Dictionary<String, Any>) {
        if let type = json["type"] as? FaceBeautifyType {
            self.type = type
        }
        if let value = json["value"] as? Int {
            self.value = value
        }
        if let imageName = json["imageName"] as? String {
            self.imageName = imageName
        }
        if let name = json["name"] as? String {
            self.name = name
        }
    }
}
