//
//  CreateRoomRequest.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/27.
//

import Foundation

struct CreateRoomRequest : Request {
    var path = "/v1/room/create_room"
    var method: HTTPMethod = .POST
    typealias Response = RequestStatus
    var parameter = Dictionary<String, AnyObject>()
    
    var name = "" {
        willSet {
            parameter["name"] = newValue as AnyObject
        }
    }
    var hostID = "" {
        willSet {
            parameter["hostID"] = newValue as AnyObject
        }
    }
    var type = 0 {
        willSet {
            parameter["type"] = newValue as AnyObject
        }
    }
    
    init() {
        parameter["type"] = 0 as AnyObject
    }
}
