//
//  UserService+Paramater.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/25.
//

import Foundation
import ZIM

// MARK: - Private
extension UserService {    
    // get request or cancel request to host parameters
    func getRequestOrCancelToHostParameters(_ isRequest: Bool) ->
    ([String: String], String, ZIMRoomAttributesSetConfig)? {
        guard let hostID = RoomManager.shared.roomService.info.hostID,
              let roomID = RoomManager.shared.roomService.info.roomID,
              let myUserID = localInfo?.userID
        else {
            assert(false, "the hostID or roomID cannot be nil")
            return nil
        }
        
        let operation = RoomManager.shared.roomService.operation.copy() as! OperationCommand
        operation.action.seq += 1
        operation.action.operatorID = myUserID
        operation.action.targetID = hostID
        
        if isRequest {
            operation.action.type = .requestToCoHost
            operation.coHostList.append(myUserID)
        } else {
            operation.action.type = .cancelRequestCoHost
            operation.coHostList = operation.coHostList.filter { $0 != myUserID }
        }
        
        let config = ZIMRoomAttributesSetConfig()
        config.isDeleteAfterOwnerLeft = true
        config.isForce = true
        config.isUpdateOwner = true
        
        let attributes = operation.attributes(.coHost)
        
        return (attributes, roomID, config)
    }
    
    // get take or leave seat parameters
    func getTakeOrLeaveSeatParameters(_ isTake: Bool) ->
    ([String: String], String, ZIMRoomAttributesSetConfig)? {
        
        guard let roomID = RoomManager.shared.roomService.info.roomID,
              let myUserID = localInfo?.userID
        else {
            assert(false, "the userID or roomID cannot be nil")
            return nil
        }
        
        let operation = RoomManager.shared.roomService.operation.copy() as! OperationCommand
        operation.action.seq += 1
        operation.action.operatorID = myUserID
        operation.action.targetID = myUserID
        
        if isTake {
            operation.action.type = .takeCoHostSeat
            let seat: CoHostSeatModel = CoHostSeatModel()
            seat.userID = myUserID
            operation.seatList.append(seat)
        } else {
            operation.action.type = .leaveCoHostSeat
            operation.seatList = operation.seatList.filter { $0.userID != myUserID }
        }
        
        let config = ZIMRoomAttributesSetConfig()
        config.isDeleteAfterOwnerLeft = true
        config.isForce = true
        config.isUpdateOwner = true
        
        let attributes = operation.attributes(.seat)
        
        return (attributes, roomID, config)
    }
    
    // get the seat releated parameters
    // flag: 0 - mic, 1 - camera, 2 - mute
    func getSeatChangeParameters(_ targetUserID: String = "", enable: Bool, flag: Int) ->
    ([String: String], String, ZIMRoomAttributesSetConfig)? {
        
        guard let roomID = RoomManager.shared.roomService.info.roomID,
              let myUserID = localInfo?.userID
        else {
            assert(false, "the hostID or roomID cannot be nil")
            return nil
        }
        
        let operation = RoomManager.shared.roomService.operation.copy() as! OperationCommand
        operation.action.seq += 1
        operation.action.operatorID = myUserID
        operation.action.targetID = myUserID
        
        guard let seatModel = operation.seatList.filter({ $0.userID == myUserID }).first else {
            assert(false, "myself did not on the seat")
            return nil
        }
        if flag == 0 {
            seatModel.mic = enable
            operation.action.type = .mic
        } else if flag == 1 {
            seatModel.camera = enable
            operation.action.type = .camera
        } else if flag == 2 {
            seatModel.isMuted = enable
            operation.action.type = .mute
        }
        
        let attributes = operation.attributes(.seat)
        
        let config = ZIMRoomAttributesSetConfig()
        config.isDeleteAfterOwnerLeft = true
        config.isForce = true
        config.isUpdateOwner = true
        
        return (attributes, roomID, config)
    }
}
