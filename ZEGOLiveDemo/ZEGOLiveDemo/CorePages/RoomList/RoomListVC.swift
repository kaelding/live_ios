//
//  RoomListVC.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/27.
//

import UIKit

class RoomListVC: UIViewController {
    
    var roomInfoList: Array<RoomInfo> {
        return RoomManager.shared.roomListService.roomList
    }
    @IBOutlet weak var roomListCollectionView: UICollectionView! {
        didSet {
            roomListCollectionView.backgroundColor = UIColor.clear
            roomListCollectionView.delegate = self
            roomListCollectionView.dataSource = self
            roomListCollectionView.alwaysBounceVertical = true
            roomListCollectionView.contentInsetAdjustmentBehavior = .never
            roomListCollectionView.addSubview(refreshControl)
        }
    }
    lazy var refreshControl: UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh...")
        refreshControl.addTarget(self, action: #selector(refreshRoomList), for: .valueChanged)
        return refreshControl
    }()
    
    @IBOutlet weak var creatButton: UIButton! {
        didSet {
            creatButton.layer.cornerRadius = 22
            creatButton.clipsToBounds = true
            let layer = CAGradientLayer()
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
            layer.locations = [NSNumber(value: 0.5), NSNumber(value: 1.0)]
            let startColor = ZegoColor("A754FF")
            let endColor = ZegoColor("510DF1")
            layer.colors = [startColor.cgColor, endColor.cgColor]
            layer.frame = creatButton.bounds
            creatButton.layer.insertSublayer(layer, at: 0)
        }
    }
    
    @IBOutlet weak var emptyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.refreshRoomList()
    }
    
    // MARK: action
    @objc func refreshRoomList() {
        RoomManager.shared.roomListService.getRoomList(nil) { result in
            switch result {
            case .success(_):
                self.roomListCollectionView.isHidden = self.roomInfoList.count == 0
                self.emptyLabel.isHidden = self.roomInfoList.count > 0
                self.emptyLabel.isHidden = self.roomInfoList.count > 0
                self.roomListCollectionView.reloadData()
            case .failure(_):
                break
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: private method
    func joinLiveRoom() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveRoomVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RoomListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let num = Int(ceil(Double(self.roomInfoList.count) / 2.0))
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section > self.roomInfoList.count / 2 - 1 {
            return 2 - self.roomInfoList.count % 2;
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomListViewCell", for: indexPath) as? RoomListViewCell else {
            return RoomListViewCell()
        }
        let index = indexPath.section * 2 + indexPath.row
        if roomInfoList.count > index {
            let roomInfo = roomInfoList[index]
            cell.roomNameLabel.text = roomInfo.roomName;
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.section * 2 + indexPath.row
        if roomInfoList.count > index {
            let roomInfo = roomInfoList[index]
            guard let roomID = roomInfo.roomID else { return }
            let rtcToken = AppToken.getRtcToken(withRoomID: roomID) ?? ""
            RoomManager.shared.roomService.joinRoom(roomID, rtcToken) { result in
                switch result {
                case .success:
                    self.joinLiveRoom()
                    RoomManager.shared.roomListService.joinServerRoom(roomID, callback: nil)
                case .failure(let error):
                    var message = String(format: ZGLocalizedString("toast_join_room_fail"), error.code)
                    if case .roomNotFound = error {
                        message = ZGLocalizedString("toast_room_not_exist_fail")
                    }
                    HUDHelper.showMessage(message: message)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 13, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16 * 2 - 13) / 2.0
        return CGSize(width: width, height: width)
    }
}
