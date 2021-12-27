//
//  RoomService+Private.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/27.
//

import Foundation
import ZIM

extension RoomService {
    
    func roomAttributesUpdated(_ roomAttributes: [String: String], action: OperationAction) {
        // if the seq is invalid
        if !operation.isSeqValid(action.seq) {
            resendRoomAttributes(roomAttributes, action: action)
            return
        } else {
            self.operation.action = action
        }
        
        // update seat list
        if let seatJson = roomAttributes["seat"] {
            self.operation.updateSeatList(seatJson)
        }
        
        // update coHost list
        if let coHostJson = roomAttributes["coHost"] {
            operation.updateCoHostList(coHostJson)
            for user in RoomManager.shared.userService.userList.allObjects() {
                guard let userID = user.userID else { continue }
                if operation.coHostList.contains(userID) {
                    user.hasRequestedCoHost = true
                } else {
                    user.hasRequestedCoHost = false
                }
            }
        }
        
        
        // delegate to UI
        let myUserID = RoomManager.shared.userService.localInfo?.userID ?? ""
        if myUserID != action.targetID { return }
        
        for delegate in RoomManager.shared.userService.delegates.allObjects {
            guard let delegate = delegate as? UserServiceDelegate else { continue }
            if action.type == .requestToCoHost {
                delegate.receiveToCoHostRequest()
            } else if action.type == .cancelRequestCoHost {
                delegate.receiveCancelToCoHostRequest()
            } else if action.type == .agreeToCoHost {
                delegate.receiveToCoHostRespond(true)
            } else if action.type == .declineToCoHost {
                delegate.receiveToCoHostRespond(false)
            }
        }
    }
    
    func resendRoomAttributes(_ roomAttributes: [String: String], action: OperationAction) {
        
        // only the host can resent the room attributes
        if !RoomManager.shared.userService.isMyselfHost { return }
        
        guard let roomID = RoomManager.shared.roomService.info.roomID else { return }
        
        let operation = OperationCommand()
        operation.action = action
        operation.action.seq += 1
        
        var attributeType: OperationAttributeType = []
        // update seat list from json
        if let seatJson = roomAttributes["seat"] {
            operation.updateSeatList(seatJson)
            attributeType.insert(.seat)
        }
        
        // update coHost list from json
        if let coHostJson = roomAttributes["coHost"] {
            operation.updateCoHostList(coHostJson)
            attributeType.insert(.coHost)
        }
        
        // update the operator's seat info to local seat list
        if action.type == .mic ||
            action.type == .camera ||
            action.type == .mute {
            
            let seat = operation.seatList.filter { $0.userID == action.operatorID }.first
            operation.seatList = self.operation.seatList
            let newSeat = operation.seatList.filter { $0.userID == action.operatorID }.first
            if let seat = seat, let newSeat = newSeat {
                newSeat.updateModel(seat)
            }
        }
        
        // update the seat list
        if action.type == .takeCoHostSeat {
            let seat = operation.seatList.filter { $0.userID == action.operatorID }.first
            operation.seatList = self.operation.seatList.filter { $0.userID != action.operatorID }
            if let seat = seat { operation.seatList.append(seat) }
        }
        if action.type == .leaveCoHostSeat {
            operation.seatList = self.operation.seatList.filter { $0.userID != action.operatorID }
        }
        
        // update the co-host list
        if action.type == .requestToCoHost {
            operation.coHostList = self.operation.coHostList.filter { $0 != action.operatorID }
            operation.coHostList.append(action.operatorID)
        }
        if action.type == .cancelRequestCoHost ||
            action.type == .declineToCoHost ||
            action.type == .agreeToCoHost {
            operation.coHostList = self.operation.coHostList.filter { $0 != action.operatorID }
        }
        
        let newRoomAttributes = operation.attributes(attributeType)
        
        let config = ZIMRoomAttributesSetConfig()
        config.isDeleteAfterOwnerLeft = true
        config.isForce = true
        config.isUpdateOwner = true
        ZIMManager.shared.zim?.setRoomAttributes(newRoomAttributes, roomID: roomID, config: config, callback: { error in
            
        })
    }
    
}
