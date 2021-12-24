//
//  CoHostSeatModel.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/24.
//

import Foundation

class CoHostSeatModel : NSObject, Codable {
    
    var userID: String = ""
    var isMuted: Bool
    var mic: Bool
    var camera: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case isMuted = "mute"
        case mic = "mic"
        case camera = "cam"
    }
}
