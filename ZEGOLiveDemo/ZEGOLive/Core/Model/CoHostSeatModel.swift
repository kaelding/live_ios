//
//  CoHostSeatModel.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/24.
//

import Foundation

class CoHostSeatModel : NSObject, Codable {
    
    var userID: String = ""
    var isMuted: Bool = false
    var mic: Bool = false
    var camera: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case isMuted = "mute"
        case mic = "mic"
        case camera = "cam"
    }
}

extension CoHostSeatModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = CoHostSeatModel()
        copy.userID = userID
        copy.isMuted = isMuted
        copy.mic = mic
        copy.camera = camera
        return copy
    }
}
