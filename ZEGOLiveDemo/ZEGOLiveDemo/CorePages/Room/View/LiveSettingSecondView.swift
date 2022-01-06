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

protocol LiveSettingSecondViewDelegate {
    func settingSecondViewDidBack()
}

class LiveSettingSecondView: UIView, UITableViewDelegate, UITableViewDataSource, SettingSecondLevelCellDelegate {

    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var encodDataSource: [LiveSettingSecondLevelModel] = {
        let data = [["title": "H.264" ,"isSelected": true, "type": RTCVideoCode.h264.rawValue],
                    ["title": "H.265" ,"isSelected": false, "type": RTCVideoCode.h265.rawValue]]
        return data.map{ LiveSettingSecondLevelModel(json: $0) }
    }()
    
    lazy var audioDataSource: [LiveSettingSecondLevelModel] = {
        let data = [["title": "16Kbps" ,"isSelected": false, "type": RTCAudioBitrate.b16.rawValue],
                    ["title": "48Kbps" ,"isSelected": true, "type": RTCAudioBitrate.b48.rawValue],
                    ["title": "56kbps" ,"isSelected": false, "type": RTCAudioBitrate.b56.rawValue],
                    ["title": "128kbps" ,"isSelected": false, "type": RTCAudioBitrate.b128.rawValue],
                    ["title": "192kbps" ,"isSelected": false, "type": RTCAudioBitrate.b192.rawValue]]
        return data.map{ LiveSettingSecondLevelModel(json: $0) }
    }()
    
    lazy var videoDataSource: [LiveSettingSecondLevelModel] = {
        let data = [["title": "1920x1080" ,"isSelected": true, "type": RTCVideoPreset.p1080.rawValue],
                    ["title": "720x1280" ,"isSelected": false, "type": RTCVideoPreset.p720.rawValue],
                    ["title": "540x960" ,"isSelected": false, "type": RTCVideoPreset.p540.rawValue],
                    ["title": "360x640" ,"isSelected": false, "type": RTCVideoPreset.p360.rawValue],
                    ["title": "270x480" ,"isSelected": false, "type": RTCVideoPreset.p270.rawValue],
                    ["title": "180x320" ,"isSelected": false, "type": RTCVideoPreset.p180.rawValue]]
        return data.map{ LiveSettingSecondLevelModel(json: $0) }
    }()
    
    var delegate: LiveSettingSecondViewDelegate?
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //MARK: - SettingSecondLevelCellDelegate
    func settingSecondLevelCellSelectedClick(_ isSelected: Bool, cell: SettingSecondLevelCell) {
        let indexPath: NSIndexPath? = tableView.indexPath(for: cell) as NSIndexPath?
        if let indexPath = indexPath {
            var index: Int = 0
            for model in dataSource {
                if indexPath.row != index {
                    model.isSelected = false
                } else {
                    model.isSelected = isSelected
                    setDeviceExpressConfig(model)
                }
                index += 1
            }
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
