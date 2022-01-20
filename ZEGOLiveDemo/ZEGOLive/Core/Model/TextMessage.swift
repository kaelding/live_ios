//
//  TextMessage.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by Kael Ding on 2021/12/14.
//

import Foundation


/// Class IM message
///
/// Description: This class contains the IM message related information.
class TextMessage: NSObject {
    
    var userID: String = ""
    var message: String = ""
    
    init(_ message: String) {
        super.init()
        self.message = message
    }
}
