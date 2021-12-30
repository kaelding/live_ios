//
//  RequestMananger.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/27.
//

import Foundation
struct RequestManager {
    static let shared: RequestManager = RequestManager()
    
    //  get room list
    func getRoomListRequest(request: RoomListRequest, success:@escaping(RoomInfoList?)->(), failure:@escaping(_ roomInfoList: RoomInfoList?)->()){
        NetworkManager.shareManage.send(request){ roomInfoList in
            if roomInfoList?.requestStatus.code == 0 {
                success(roomInfoList)
            } else {
                failure(roomInfoList)
            }
        }
    }
    
    // create room
    func createRoomRequest(request: CreateRoomRequest, success:@escaping(RequestStatus?)->(), failure:@escaping(_ requestStatus: RequestStatus?)->()){
        NetworkManager.shareManage.send(request){ requestStatus in
            if (requestStatus?.code == 0) {
                success(requestStatus)
            } else {
                failure(requestStatus)
            }
        }
    }
    
    // end room
    func endRoomRequest(request: EndRoomRequest, success:@escaping(RequestStatus?)->(), failure:@escaping(_ requestStatus: RequestStatus?)->()){
        NetworkManager.shareManage.send(request){ requestStatus in
            if (requestStatus?.code == 0) {
                success(requestStatus)
            } else {
                failure(requestStatus)
            }
        }
    }
    
    // heart beat
    func heartBeatRequest(request: HeartBeatRequest, success:@escaping(RequestStatus?)->(), failure:@escaping(_ requestStatus: RequestStatus?)->()){
        NetworkManager.shareManage.send(request){ requestStatus in
            if (requestStatus?.code == 0) {
                success(requestStatus)
            } else {
                failure(requestStatus)
            }
        }
    }
    
    // get effects license
    func getEffectsLicense(request: EffectsLicenseRequest, success:@escaping(RequestStatus?)->(), failure:@escaping(_ requestStatus: RequestStatus?)->()){
        NetworkManager.shareManage.send(request){ requestStatus in
            if (requestStatus?.code == 0) {
                success(requestStatus)
            } else {
                failure(requestStatus)
            }
        }
    }
}








