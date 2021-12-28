//
//  RoomListRequest.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/27.
//

import Foundation
import UIKit

struct RoomListRequest: Request {
    var path = "/v1/room/get_room_list"
    var method: HTTPMethod = .POST
    typealias Response = RoomInfoList
    var parameter = Dictionary<String, AnyObject>()
    
    var pageNum = 100 {
        willSet {
            parameter["page_num"] = newValue as AnyObject
        }
    }
    var from = "" {
        willSet {
            parameter["form"] = newValue as AnyObject
        }
    }
    var type = 0 {
        willSet {
            parameter["type"] = newValue as AnyObject
        }
    }
    
    init() {
        parameter["page_num"] = 100 as AnyObject
        parameter["type"] = 0 as AnyObject
    }
}
