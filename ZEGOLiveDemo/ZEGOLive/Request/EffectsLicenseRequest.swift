//
//  EffectsLicenseRequest.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import Foundation

struct EffectsLicenseRequest : Request {
    
    var path = ""
    var method: HTTPMethod = .GET
    typealias Response = RequestStatus
    var parameter = Dictionary<String, AnyObject>()
    
    var appID : UInt32 = 0 {
        willSet {
            parameter["AppId"] = newValue as AnyObject
        }
    }
    
    var authInfo = "" {
        willSet {
            parameter["AuthInfo"] = newValue as AnyObject
        }
    }
    
    init() {
        parameter["Action"] = "DescribeEffectsLicense" as AnyObject
        parameter["host"] = "https://aieffects-api.zego.im" as AnyObject
    }
}
