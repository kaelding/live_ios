//
//  LiveSettingModel.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/5.
//

import UIKit

class LiveSettingModel: NSObject {
    
    var title:String?
    var subTitle:String?
    var selectionType: ZegoDevicesType = .noiseSuppression
    var switchStatus: Bool = false
    
    init(json: Dictionary<String, Any>) {
        if let title = json["title"] as? String {
            self.title = title
        }
        if let subTitle = json["subTitle"] as? String {
            self.subTitle = subTitle
        }
        if let selectionType = json["selectionType"] as? ZegoDevicesType {
            self.selectionType = selectionType
        }
        if let switchStatus = json["switchStatus"] as? Bool {
            self.switchStatus = switchStatus
        }
    }
}
