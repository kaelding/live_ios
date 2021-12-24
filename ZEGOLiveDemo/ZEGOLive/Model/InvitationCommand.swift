//
//  InvitationCommand.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/24.
//

import Foundation

class InvitationCommand : NSObject {
    enum CommandType : Int {
        case invitation = 1
    }
    
    var targetUserID: String?
    var type: CommandType = .invitation
    
    init(with json: String) {
        let dict = ZegoJsonTool.jsonToDictionary(json)
        guard let dict = dict else {
            return
        }
        let typeValue = dict["actionType"] as? Int ?? 1
        self.type = CommandType(rawValue: typeValue) ?? .invitation
        if let userID = dict["target"] as? String {
            self.targetUserID = userID
        }
    }
    
    func json() -> String? {
        var dict: [String: Any] = [:]
        dict["actionType"] = type.rawValue
        dict["target"] = targetUserID ?? ""
        let jsonStr = ZegoJsonTool.dictionaryToJson(dict)
        return jsonStr
    }
}
