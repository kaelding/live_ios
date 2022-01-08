//
//  LiveSettingSecondView.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/6.
//

import UIKit

enum SettingSecondViewType: Int {
    case resolution
    case audio
    case encoding
}

protocol LiveSettingSecondViewDelegate: AnyObject {
    func settingSecondViewDidBack()
}

class LiveSettingSecondView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roundView: UIView!
    
    lazy var encodDataSource: [LiveSettingSecondLevelModel] = {
        let data = [["title": "H.264" ,"isSelected": (RoomManager.shared.deviceService.videoCodeID == .h264), "type": RTCVideoCode.h264.rawValue],
                    ["title": "H.265" ,"isSelected": (RoomManager.shared.deviceService.videoCodeID == .h265), "type": RTCVideoCode.h265.rawValue]]
        return data.map{ LiveSettingSecondLevelModel(json: $0) }
    }()
    
    lazy var audioDataSource: [LiveSettingSecondLevelModel] = {
        let data = [["title": "16Kbps" ,"isSelected": (RoomManager.shared.deviceService.audioBitrate == .b16), "type": RTCAudioBitrate.b16.rawValue],
                    ["title": "48Kbps" ,"isSelected": (RoomManager.shared.deviceService.audioBitrate == .b48), "type": RTCAudioBitrate.b48.rawValue],
                    ["title": "56kbps" ,"isSelected": (RoomManager.shared.deviceService.audioBitrate == .b56), "type": RTCAudioBitrate.b56.rawValue],
                    ["title": "128kbps" ,"isSelected": (RoomManager.shared.deviceService.audioBitrate == .b128), "type": RTCAudioBitrate.b128.rawValue],
                    ["title": "192kbps" ,"isSelected": (RoomManager.shared.deviceService.audioBitrate == .b192), "type": RTCAudioBitrate.b192.rawValue]]
        return data.map{ LiveSettingSecondLevelModel(json: $0) }
    }()
    
    lazy var videoDataSource: [LiveSettingSecondLevelModel] = {
        let data = [["title": "1920x1080" ,"isSelected": (RoomManager.shared.deviceService.videoPreset == .p1080), "type": RTCVideoPreset.p1080.rawValue],
                    ["title": "720x1280" ,"isSelected": (RoomManager.shared.deviceService.videoPreset == .p720), "type": RTCVideoPreset.p720.rawValue],
                    ["title": "540x960" ,"isSelected": (RoomManager.shared.deviceService.videoPreset == .p540), "type": RTCVideoPreset.p540.rawValue],
                    ["title": "360x640" ,"isSelected": (RoomManager.shared.deviceService.videoPreset == .p360), "type": RTCVideoPreset.p360.rawValue],
                    ["title": "270x480" ,"isSelected": (RoomManager.shared.deviceService.videoPreset == .p270), "type": RTCVideoPreset.p270.rawValue],
                    ["title": "180x320" ,"isSelected": (RoomManager.shared.deviceService.videoPreset == .p180), "type": RTCVideoPreset.p180.rawValue]]
        return data.map{ LiveSettingSecondLevelModel(json: $0) }
    }()
    
    weak var delegate: LiveSettingSecondViewDelegate?
    var viewType: SettingSecondViewType = .resolution
    var dataSource: [LiveSettingSecondLevelModel] = []
    
    func setShowDataSourceType(_ type: SettingSecondViewType) -> Void {
        viewType = type
        switch type {
        case .resolution:
            titleLabel.text = "Resolution Settings"
            dataSource = videoDataSource
        case .audio:
            titleLabel.text = "Audio bitrate"
            dataSource = audioDataSource
        case .encoding:
            titleLabel.text = "Encoding type"
            dataSource = encodDataSource
        }
        tableView.reloadData()
    }
    
    
    @IBAction func backClick(_ sender: UIButton) {
        self.isHidden = true
        delegate?.settingSecondViewDidBack()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "SettingSecondLevelCell", bundle: nil), forCellReuseIdentifier: "SettingSecondLevelCell")
        tableView.backgroundColor = UIColor.clear
        
        topLineView.layer.masksToBounds = true
        topLineView.layer.cornerRadius = 2.5
        
        let tapClick: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        backGroundView.addGestureRecognizer(tapClick)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipRoundCorners()
    }
    
    func clipRoundCorners() -> Void {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: roundView.bounds.size.width, height: roundView.bounds.size.height), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = roundView.bounds
        maskLayer.path = maskPath.cgPath
        roundView.layer.mask = maskLayer
    }
    
    @objc func tapClick() -> Void {
        self.isHidden = true
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingSecondLevelCell") as? SettingSecondLevelCell else {
            return SettingSecondLevelCell()
        }
        let model: LiveSettingSecondLevelModel = dataSource[indexPath.row]
        cell.updateCell(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index: Int = 0
        for model in dataSource {
            if indexPath.row != index {
                model.isSelected = false
            } else {
                model.isSelected = true
                setDeviceExpressConfig(model)
            }
            index += 1
        }
        tableView.reloadData()
    }
    
    func setDeviceExpressConfig(_ model: LiveSettingSecondLevelModel) -> Void {
        switch viewType {
        case .resolution:
            let type: RTCVideoPreset = RTCVideoPreset(rawValue: model.type) ?? .p1080
            RoomManager.shared.deviceService.setVideoPreset(type)
        case .audio:
            let type: RTCAudioBitrate = RTCAudioBitrate(rawValue: model.type) ?? .b48
            RoomManager.shared.deviceService.setAudioBitrate(type)
        case .encoding:
            let type: RTCVideoCode = RTCVideoCode(rawValue: model.type) ?? .h264
            RoomManager.shared.deviceService.setVideoCodeID(type)
        }
    }
    
}
