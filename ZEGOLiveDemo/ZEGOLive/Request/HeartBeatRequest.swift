//
//  HeartBeatRequest.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/27.
//

import Foundation

struct HeartBeatRequest : Request {
    var path = "/v1/room/heartbeat"
    var method: HTTPMethod = .POST
    typealias Response = RequestStatus
    var parameter = Dictionary<String, AnyObject>()
    
    var roomID = "" {
        willSet {
            parameter["id"] = newValue as AnyObject
        }
    }
    
    var userID = "" {
        willSet {
            parameter["user_id"] = newValue as AnyObject
        }
    }
    
    var type = 0 {
        willSet {
            parameter["type"] = newValue as AnyObject
        }
    }
    
    var keepRoom = false {
        willSet {
            parameter["keep_room"] = newValue as AnyObject
        }
    }
    
    init() {
        parameter["type"] = 0 as AnyObject
        parameter["keep_room"] = 0 as AnyObject
    }
}
