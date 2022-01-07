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
        cell.model = model
        cell.delegate = self
        startPlaying(model.userID, streamView: cell.streamView)
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
        let muteTitle = model.isMuted ? "Unmute" : "Mute"
        let muteAction = UIAlertAction(title: muteTitle, style: .default) { action in
            RoomManager.shared.userService.muteUser(!model.isMuted, userID: model.userID) { result in
                if result.isSuccess {
                    model.isMuted = !model.isMuted
                    self.coHostCollectionView.reloadData()
                } else {
                    HUDHelper.showMessage(message: "Failed to operate， please try it again")
                }
            }
        }
        let prohibitAction = UIAlertAction(title: "Prohibit to connect", style: .default) { action in
            //TODO: to add prohibit to connect logic.
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
                startPlaying(hostSeat.userID, streamView: streamView)
            }
        }
        setCoHostList()
        updateCollectionViewConstraint()
        coHostCollectionView.reloadData()
    }
    
    private func startPlaying(_ userID: String?, streamView: UIView) {
        let streamID = String.getStreamID(userID, roomID: getRoomID())
        let canvas = ZegoCanvas(view: streamView)
        canvas.viewMode = .aspectFill
        ZegoExpressEngine.shared().startPlayingStream(streamID, canvas: canvas)
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
    private var coHostList: [CoHostSeatModel] {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.identifier) as? [CoHostSeatModel] ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.identifier, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}
