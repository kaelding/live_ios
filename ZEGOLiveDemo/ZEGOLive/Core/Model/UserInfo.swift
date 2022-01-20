//
//  UserInfo.swift
//  ZegoLiveAudioRoomDemo
//
//  Created by Kael Ding on 2021/12/13.
//

import Foundation

enum UserRole: Codable {
    /// Participant
    case participant
    /// co-host
    case coHost
    /// Host
    case host
}


/// Class user information
///
/// Description: This class contains the user related information.
class UserInfo: NSObject, Codable {
    /// User ID, refers to the user unique ID, can only contains numbers and letters.
    var userID: String?
    
    /// User name, cannot be null.
    var userName: String?
    
    /// User role
    var role: UserRole = .participant
    
    // MARK: - local property
    /// Indicates whether the user has taken a co-host seat.
    var hasRequestedCoHost: Bool = false
    /// Indicates whether the user has requested to co-host.
    var hasInvited: Bool = false
    
    override init() {
        
    }
    
    init(_ userID: String, _ userName: String, _ role: UserRole) {
        self.userID = userID
        self.userName = userName
        self.role = role
    }
}
