//
//  Command.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/24.
//

import Foundation
import UIKit

struct OperationAttributeType : OptionSet {
    let rawValue: Int
    static let seat = OperationAttributeType(rawValue: 4)
    static let coHost = OperationAttributeType(rawValue: 8)
    // the -1 every bit is 1
    static let all = OperationAttributeType(rawValue: -1)
}

enum OperationActionType : Int, Codable {
    case mic = 100
    case camera = 101
    case mute = 102
    case takeCoHostSeat = 103
    case leaveCoHostSeat = 104
    case requestToCoHost = 200
    case cancelRequestCoHost = 201
    case declineToCoHost = 202
    case agreeToCoHost = 203
}

struct OperationAction : Codable {
    var seq: Int = 0
    var type: OperationActionType?
    var targetID: String = ""
    var operatorID: String = ""
    
    enum CodingKeys: String, CodingKey {
        case seq = "seq"
        case type = "type"
        case targetID = "targetID"
        case operatorID = "operatorID"
    }
}

class OperationCommand : NSObject, Codable {
    var seatList: [CoHostSeatModel] = []
    var coHostList: [String] = []
    var action: OperationAction = OperationAction()
    
    enum CodingKeys: String, CodingKey {
        case seatList = "seat"
        case coHostList = "coHost"
        case action = "action"
    }
    
    func json() -> String? {
        let jsonStr = ZegoJsonTool.modelToJson(toString: self)
        return jsonStr
    }
    
    func attributes(_ type: OperationAttributeType) -> [String: String] {
        var attributes: [String: String] = [:]
        if let actionJson = ZegoJsonTool.modelToJson(toString: action) {
            attributes["action"] = actionJson
        }
        
        if type.contains(.seat) {
            if let seatListJson = ZegoJsonTool.modelToJson(toString: seatList) {
                attributes["seat"] = seatListJson
            }
        }
        
        if type.contains(.coHost) {
            if let coHostJson = ZegoJsonTool.modelToJson(toString: coHostList) {
                attributes["coHost"] = coHostJson
            }
        }
        
        return attributes
    }
    
    func isSeqValid(_ seq: Int) -> Bool {
        if seq == 0 && action.seq == 0 { return true }
        if seq > 0 && seq > action.seq { return true }
        return false
    }
    
    func updateSeatList(_ json: String) {
        guard let arr = ZegoJsonTool.jsonToArrary(json) else { return }
        var list: [CoHostSeatModel] = []
        for seatDict in arr {
            guard let seatDict = seatDict as? [String: Any] else { return }
            guard let seat = ZegoJsonTool.dictionaryToModel(type: CoHostSeatModel.self, dict: seatDict) else { return }
            list.append(seat)
        }
        self.seatList = list
        RoomManager.shared.userService.coHostList = list
    }
    
    func updateCoHostList(_ json: String) {
        guard let arr = ZegoJsonTool.jsonToArrary(json) else { return }
        var list: [String] = []
        for userID in arr {
            guard let userID = userID as? String else { return }
            list.append(userID)
        }
        self.coHostList = list
    }
}

extension OperationCommand: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = OperationCommand()
        copy.seatList = self.seatList.compactMap({ seat in
            seat.copy() as? CoHostSeatModel
        })
        copy.coHostList = self.coHostList
        copy.action = OperationAction()
        copy.action.seq = self.action.seq
        return copy
    }
}
