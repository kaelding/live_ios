//
//  CoHostSeatModel.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/24.
//

import Foundation


/// Class co-host seat status information
///
/// Description: This class contains the co-host seat status information.
class CoHostModel : NSObject, Codable {
    
    /// User ID
    var userID: String = ""
    
    /// Indicates whether the user has been muted. Once the participant has been muted, the participant can only keep camera on and send text messages to chat.
    var isMuted: Bool = false
    
    /// Indicates the microphone status.
    var mic: Bool = true
    
    /// Indicates the camera status.
    var camera: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case isMuted = "mute"
        case mic = "mic"
        case camera = "cam"
    }
}

extension CoHostModel: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = CoHostModel()
        copy.userID = userID
        copy.isMuted = isMuted
        copy.mic = mic
        copy.camera = camera
        return copy
    }
    
    func updateModel(_ oldModel: CoHostModel) {
        self.userID = oldModel.userID
        self.isMuted = oldModel.isMuted
        self.mic = oldModel.mic
        self.camera = oldModel.camera
    }
}
