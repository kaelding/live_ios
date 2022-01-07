//
//  LiveRoomVC+CoHost.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2022/1/6.
//

import Foundation

extension LiveRoomVC :
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = RoomManager.shared.userService.coHostList.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoHostCell", for: indexPath) as! CoHostCell
        cell.model = RoomManager.shared.userService.coHostList[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    func updateCollectionViewHeight() {
        let count = RoomManager.shared.userService.coHostList.count
        var height = CGFloat(count) * (124.0 + 8.0) - 8.0
        if height < 124.0 {
            height = 124.0
        }
        if height > 388.0 {
            height = 388.0
        }
        coHostViewHeightConstraint.constant = height
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
