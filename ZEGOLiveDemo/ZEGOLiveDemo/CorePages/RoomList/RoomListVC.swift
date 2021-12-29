//
//  RoomListVC.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/27.
//

import UIKit

class RoomListVC: UIViewController {
    
    var roomInfoList = RoomInfoList()

    @IBOutlet weak var roomListCollectionView: UICollectionView! {
        didSet {
            roomListCollectionView.backgroundColor = UIColor.clear
            
            roomListCollectionView.delegate = self
            roomListCollectionView.dataSource = self
        }
    }
    
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
        self.refreshRoomList()
    }
    
    // MARK: action
    @IBAction func pressCreateButton(_ sender: UIButton) {
        let alter:UIAlertController = UIAlertController.init(title: ZGLocalizedString("create_page_create_room"), message: "", preferredStyle: UIAlertController.Style.alert)
        let cancelAction:UIAlertAction = UIAlertAction.init(title: ZGLocalizedString("create_page_cancel"), style: UIAlertAction.Style.cancel, handler: nil)
        let createAction:UIAlertAction = UIAlertAction.init(title: ZGLocalizedString("create_page_create"), style: UIAlertAction.Style.default) { action in
            let roomNameTextField = (alter.textFields?.last)!
            self.createRoomWithRoomName( roomName: roomNameTextField.text! as String)
        }
        alter.addTextField { textField in
            textField.placeholder = ZGLocalizedString("create_page_room_name")
            textField.font = UIFont.systemFont(ofSize: 14)
            textField.addTarget(self, action: #selector(self.createRoomNameTextFieldDidChange), for: UIControl.Event.editingChanged)
        }
        alter.addAction(cancelAction)
        alter.addAction(createAction)
        self.present(alter, animated: true, completion: nil)
    }
    
    // MARK: private method
    @objc func createRoomNameTextFieldDidChange(textField:UITextField) -> Void {
        let text:String = textField.text! as String
        if text.count > 16 {
            let startIndex = text.index(text.startIndex, offsetBy: 0)
            let index = text.index(text.startIndex, offsetBy: 15)
            textField.text = String(text[startIndex...index])
        }
    }
    
    func createRoomWithRoomName(roomName: String) -> Void {
        var message:String = ""
        if roomName.count == 0 {
            message = ZGLocalizedString("toast_room_name_error")
        }
        if message.count > 0 {
            HUDHelper .showMessage(message: message)
            return
        }
        
        HUDHelper.showNetworkLoading()
        var request = CreateRoomRequest()
        request.name = roomName
        request.hostID = "123"
        RequestManager.shared.createRoomRequest(request: request) { status in
            HUDHelper.hideNetworkLoading()
            self.refreshRoomList()
        } failure: { requestStatus in
            let message = String(format: ZGLocalizedString("toast_create_room_fail"), requestStatus?.code ?? 0)
            HUDHelper.showMessage(message: message)
        }
    }
    
    func refreshRoomList() {
        let request = RoomListRequest()
        RequestManager.shared.getRoomListRequest(request: request) { roomInfoList in
            guard let roomInfoList = roomInfoList else { return }
            
            self.roomListCollectionView.isHidden = roomInfoList.roomInfoArray.count == 0
            self.emptyLabel.isHidden = roomInfoList.roomInfoArray.count > 0
            self.emptyLabel.isHidden = roomInfoList.roomInfoArray.count > 0
            
            self.roomInfoList = roomInfoList
            self.roomListCollectionView.reloadData()
        } failure: { roomInfoList in
        }
    }
}

extension RoomListVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let num = Int(ceil(Double(self.roomInfoList.roomInfoArray.count) / 2.0))
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section > self.roomInfoList.roomInfoArray.count / 2 - 1 {
            return 2 - self.roomInfoList.roomInfoArray.count % 2;
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoomListViewCell", for: indexPath) as? RoomListViewCell else {
            return RoomListViewCell()
        }
        let index = indexPath.section * 2 + indexPath.row
        if roomInfoList.roomInfoArray.count > index {
            let roomInfo = roomInfoList.roomInfoArray[index]
            cell.roomNameLabel.text = roomInfo.roomName;
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
