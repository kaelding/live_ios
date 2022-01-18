//
//  LiveRoomVC+CoHost.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2022/1/6.
//

import Foundation
import ZegoExpressEngine

extension LiveRoomVC :
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coHostList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoHostCell", for: indexPath) as! CoHostCell
        let model = coHostList[indexPath.row]
        cell.moreButton.isHidden = getUser(localUserID)?.role != .host
        cell.model = model
        cell.delegate = self
        RoomManager.shared.deviceService.playVideoStream(model.userID, view: cell.streamView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func updateCollectionViewConstraint() {
        let count = coHostList.count
        var height = CGFloat(count) * (124.0 + 8.0) - 8.0
        if height < 124.0 {
            height = 124.0
        }
        if height > 388.0 {
            height = 388.0
        }
        coHostViewHeightConstraint.constant = height
        coHostCollectionView.isHidden = count <= 0
    }
}

extension LiveRoomVC : CoHostCellDelegate {
    func moreButtonClick(_ cell: CoHostCell) {
        guard let model = cell.model else { return }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let muteTitle = model.isMuted ? ZGLocalizedString("room_page_unmute") : ZGLocalizedString("room_page_mute")
        let muteAction = UIAlertAction(title: muteTitle, style: .default) { action in
            RoomManager.shared.userService.muteUser(!model.isMuted, userID: model.userID) { result in
                if result.isFailure {
                    TipView.showWarn(ZGLocalizedString("toast_room_failed_to_operate"))
                }
            }
        }
        let prohibitAction = UIAlertAction(title: ZGLocalizedString("room_page_prohibit_to_connect"), style: .default) { action in
            RoomManager.shared.userService.removeUserFromSeat(model.userID) { result in
                if result.isFailure {
                    TipView.showWarn(ZGLocalizedString("toast_room_failed_to_operate"))
                }
            }
        }
        let cancelAction = UIAlertAction(title: ZGLocalizedString("dialog_room_page_cancel"), style: .cancel, handler: nil)
        alert.addAction(muteAction)
        alert.addAction(prohibitAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension LiveRoomVC {
    func reloadCoHost() {
        
        if let hostSeat = RoomManager.shared.userService.coHostList.filter({ $0.userID ==  getHostID()}).first {
            if !isMyselfHost {
                RoomManager.shared.deviceService.playVideoStream(hostSeat.userID, view: streamView)
            }
        }
        setCoHostList()
        updateCollectionViewConstraint()
        coHostCollectionView.reloadData()
    }
        
    private func setCoHostList() {
        let mySeat = RoomManager.shared.userService.coHostList.filter({
            $0.userID == localUserID && $0.userID != getHostID()
        }).first
        var list = RoomManager.shared.userService.coHostList.filter {
            $0.userID != localUserID && $0.userID != getHostID()
        }
        if let mySeat = mySeat {
            if !isMyselfHost { list.insert(mySeat, at: 0) }
        }
        coHostList = list
    }
}


extension LiveRoomVC {
    private struct AssociatedKey {
        static var identifier: String = "identifier_dataSource"
    }
    private var coHostList: [CoHostModel] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.identifier) as? [CoHostModel] ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.identifier, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}
