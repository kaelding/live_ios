//
//  Command.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/24.
//

import Foundation
import UIKit

var requestSeq: Int = 0

struct OperationAttributeType : OptionSet {
    let rawValue: Int
    static let coHost = OperationAttributeType(rawValue: 1)
    static let requestCoHost = OperationAttributeType(rawValue: 2)
    // the -1 every bit is 1
    static let all = OperationAttributeType(rawValue: -1)
}

enum OperationActionType : Int, Codable {
    case mic = 100
    case camera = 101
    case mute = 102
    case takeSeat = 103
    case leaveSeat = 104
    case requestToCoHost = 200
    case cancelRequestCoHost = 201
    case declineToCoHost = 202
    case agreeToCoHost = 203
}

struct OperationAction : Codable {
    var seq: Int = 0 {
        didSet {
            if seq > requestSeq {
                requestSeq = seq
            }
        }
    }
    var type: OperationActionType?
    var targetID: String = ""
    var operatorID: String = ""
    
    enum CodingKeys: String, CodingKey {
        case seq = "seq"
        case type = "type"
        case targetID = "target_id"
        case operatorID = "operator_id"
    }
}

class OperationCommand : NSObject, Codable {
    var coHost: [CoHostModel] = []
    var requestCoHost: [String] = []
    var action: OperationAction = OperationAction()
    
    enum CodingKeys: String, CodingKey {
        case coHost = "co_host"
        case requestCoHost = "request_co_host"
        case action = "action"
    }
    
    func addSeq() {
        if requestSeq > action.seq {
            action.seq = requestSeq + 1
        } else {
            action.seq += 1
        }
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
        
        if type.contains(.coHost) {
            if let seatListJson = ZegoJsonTool.modelToJson(toString: coHost) {
                attributes["co_host"] = seatListJson
            }
        }
        
        if type.contains(.requestCoHost) {
            if let coHostJson = ZegoJsonTool.modelToJson(toString: requestCoHost) {
                attributes["request_co_host"] = coHostJson
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
        guard let arr = ZegoJsonTool.jsonToArray(json) else { return }
        var list: [CoHostModel] = []
        let targetCoHost = coHost.filter({ $0.userID == action.targetID }).first
        var updateCoHost: CoHostModel?
        for seatDict in arr {
            guard let seatDict = seatDict as? [String: Any] else { return }
            guard let seat = ZegoJsonTool.dictionaryToModel(type: CoHostModel.self, dict: seatDict) else { return }
            if list.compactMap({ $0.userID }).contains(seat.userID) { continue }
            if list.count >= MAX_SEAT_COUNT { break }
            list.append(seat)
            if seat.userID == action.targetID {
                updateCoHost = seat
            }
        }
        // if the action type is .camera, .mic, .mute, only update the this value
        if let updateCoHost = updateCoHost,
           let targetCoHost = targetCoHost {
            if action.type == .camera {
                targetCoHost.camera = updateCoHost.camera
            } else if action.type == .mic {
                targetCoHost.mic = updateCoHost.mic
            } else if action.type == .mute {
                targetCoHost.isMuted = updateCoHost.isMuted
            } else {
                self.coHost = list
            }
        } else {
            self.coHost = list
        }
    }
    
    func updateRequestCoHostList(_ json: String) {
        guard let arr = ZegoJsonTool.jsonToArray(json) else { return }
        var list: [String] = []
        for userID in arr {
            guard let userID = userID as? String else { return }
            if list.contains(userID) { continue }
            list.append(userID)
        }
        self.requestCoHost = list
    }
}

extension OperationCommand: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = OperationCommand()
        copy.coHost = self.coHost.compactMap({ seat in
            seat.copy() as? CoHostModel
        })
        copy.requestCoHost = self.requestCoHost
        copy.action = OperationAction()
        copy.action.seq = self.action.seq
        return copy
    }
}
