//
//  MoreSettingView.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/7.
//

import UIKit

enum MoreSettingViewSelectedType {
    case setting
}

protocol MoreSettingViewDelegate: AnyObject {
    func moreSettingViewDidSelectedCell(_ type: MoreSettingViewSelectedType)
}

class MoreSettingView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    weak var delegate: MoreSettingViewDelegate?
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    lazy var dataSource: [MoreSettingModel] = {
        let data = [["title": "Flip" ,"imageName": "bottombar_flip", "type": selectedType.flip, "isSelected": false],
                    ["title": "Camera" ,"imageName": "bottombar_cam_on", "type": selectedType.camera, "isSelected": false],
                    ["title": "Mute" ,"imageName": "bottombar_mic_on", "type": selectedType.mute, "isSelected": false],
                    ["title": "Settings" ,"imageName": "bottombar_more", "type": selectedType.setting, "isSelected": false]]
        return data.map{ MoreSettingModel(json: $0) }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ZGLocalizedString("room_settings_page_more")
        
        topLineView.layer.masksToBounds = true
        topLineView.layer.cornerRadius = 2.5
        
        let tapClick: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        backGroundView.addGestureRecognizer(tapClick)
        
        iconCollectionView.delegate = self
        iconCollectionView.dataSource = self
        iconCollectionView.backgroundColor = UIColor.clear
        iconCollectionView.register(UINib.init(nibName: "MoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MoreCollectionViewCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipRoundCorners()
    }
    
    func clipRoundCorners() -> Void {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: containerView.bounds.size.width, height: containerView.bounds.size.height), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = containerView.bounds
        maskLayer.path = maskPath.cgPath
        containerView.layer.mask = maskLayer
    }
    
    @objc func tapClick() -> Void {
        self.isHidden = true
    }
    
    //MARK: -UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:MoreCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCollectionViewCell", for: indexPath) as! MoreCollectionViewCell
        let model: MoreSettingModel = dataSource[indexPath.row]
        cell.updateCell(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 68, height: 122)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: MoreSettingModel = dataSource[indexPath.row]
        model.isSelected = !model.isSelected
        switch model.type {
        case .flip:
            RoomManager.shared.deviceService.useFrontCamera(!model.isSelected)
        case .camera:
            model.imageName = model.isSelected ? "bottombar_cam_off" : "bottombar_cam_on"
            RoomManager.shared.deviceService.enableCamera(!model.isSelected)
        case .mute:
            model.imageName = model.isSelected ? "bottombar_mic_off" : "bottombar_mic_on"
            RoomManager.shared.deviceService.muteMicrophone(model.isSelected)
        case .data:
            break
        case .setting:
            delegate?.moreSettingViewDidSelectedCell(.setting)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 14, bottom: 0, right: 14)
    }
    
}
