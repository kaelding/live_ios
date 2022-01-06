//
//  LiveSettingView.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/5.
//

import UIKit

protocol LiveSettingViewDelegate {
    func settingViewDidSelected(_ model: LiveSettingModel)
}

class LiveSettingView: UIView, UITableViewDelegate, UITableViewDataSource, SettingSwitchCellDelegate {

    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    
    var delegate: LiveSettingViewDelegate?
    
    lazy var settingDataSource: [LiveSettingModel] = {
        let dataSource = [["title": "Encoding type" ,"subTitle": "H.264", "selectionType": SettingSelectionType.encoding, "switchStatus": false],
                          ["title": "Layered coding" ,"subTitle": "", "selectionType": SettingSelectionType.layered, "switchStatus": false],
                          ["title": "Hardware coding" ,"subTitle": "", "selectionType": SettingSelectionType.hardware, "switchStatus": false],
                          ["title": "Hardware decoding" ,"subTitle": "", "selectionType": SettingSelectionType.decoding, "switchStatus": false],
                          ["title": "Background noise reduction" ,"subTitle": "", "selectionType": SettingSelectionType.noise, "switchStatus": false],
                          ["title": "Echo cancellation" ,"subTitle": "", "selectionType": SettingSelectionType.echo, "switchStatus": false],
                          ["title": "Mic volume auto-adjustment" ,"subTitle": "", "selectionType": SettingSelectionType.volume, "switchStatus": false],
                          ["title": "Resolution settings" ,"subTitle": "1080x1920", "selectionType": SettingSelectionType.resolution, "switchStatus": false],
                          ["title": "Audio bitrate" ,"subTitle": "48kbps", "selectionType": SettingSelectionType.bitrate, "switchStatus": false]]
        return dataSource.map{ LiveSettingModel(json: $0) }
    }()
    
    lazy var resolutionDic: [RTCVideoPreset:String] = {
        let dic: [RTCVideoPreset:String] = [RTCVideoPreset.p1080:"1920x1080",
                                            RTCVideoPreset.p720:"720x1280",
                                            RTCVideoPreset.p540:"540x960",
                                            RTCVideoPreset.p360:"360x640",
                                            RTCVideoPreset.p270:"270x480",
                                            RTCVideoPreset.p180:"182x320"]
        return dic
    }()
    
    lazy var bitrateDic: [RTCAudioBitrate:String] = {
        let dic: [RTCAudioBitrate:String] = [RTCAudioBitrate.b16:"16kbps",
                                             RTCAudioBitrate.b48:"48kbps",
                                             RTCAudioBitrate.b56:"56kbps",
                                             RTCAudioBitrate.b128:"128kbps",
                                             RTCAudioBitrate.b192:"192kbps"]
        return dic
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingTableView.register(UINib.init(nibName: "SettingSwitchCell", bundle: nil), forCellReuseIdentifier: "SettingSwitchCell")
        settingTableView.register(UINib.init(nibName: "SettingParamDisplayCell", bundle: nil), forCellReuseIdentifier: "SettingParamDisplayCell")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(UINib.init(nibName: "SettingSwitchCell", bundle: nil), forCellReuseIdentifier: "SettingSwitchCell")
        settingTableView.register(UINib.init(nibName: "SettingParamDisplayCell", bundle: nil), forCellReuseIdentifier: "SettingParamDisplayCell")
        settingTableView.backgroundColor = UIColor.clear
        
        topLineView.layer.masksToBounds = true
        topLineView.layer.cornerRadius = 2.5
        
        updateUI()
        
        let tapClick: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        backGroundView.addGestureRecognizer(tapClick)
    }
    
    func updateUI() -> Void {
        for model in settingDataSource {
            switch model.selectionType {
            case .encoding:
                model.subTitle = RoomManager.shared.deviceService.videoCodeID == .h264 ? "H.264":"H.265"
            case .layered:
                model.switchStatus = RoomManager.shared.deviceService.layerCoding
            case .hardware:
                model.switchStatus = RoomManager.shared.deviceService.hardwareCoding
            case .decoding:
                model.switchStatus = RoomManager.shared.deviceService.hardwareDecoding
            case .noise:
                model.switchStatus = RoomManager.shared.deviceService.noiseRedution
            case .echo:
                model.switchStatus = RoomManager.shared.deviceService.echo
            case .volume:
                model.switchStatus = RoomManager.shared.deviceService.micVolume
            case .resolution:
                model.subTitle = resolutionDic[RoomManager.shared.deviceService.videoPreset]
                break
            case .bitrate:
                model.subTitle = bitrateDic[RoomManager.shared.deviceService.audioBitrate]
                break
            }
        }
        settingTableView.reloadData()
    }
    
    
    @objc func tapClick() -> Void {
        self.isHidden = true
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model: LiveSettingModel = settingDataSource[indexPath.row]
        switch model.selectionType {
            case .noise, .echo, .volume, .layered, .hardware, .decoding:
                let cell: SettingSwitchCell = tableView.dequeueReusableCell(withIdentifier: "SettingSwitchCell") as! SettingSwitchCell
                cell.updateCell(model)
                cell.delegate = self
                return cell
            case .resolution, .bitrate, .encoding:
                let cell: SettingParamDisplayCell = tableView.dequeueReusableCell(withIdentifier: "SettingParamDisplayCell") as! SettingParamDisplayCell
                cell.updateCell(model)
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: LiveSettingModel = settingDataSource[indexPath.row]
        switch model.selectionType {
            case .noise, .echo, .volume:
            break
        case .encoding, .resolution, .bitrate:
            delegate?.settingViewDidSelected(model)
        case .layered:
            break
        case .hardware:
            break
        case .decoding:
            break
        }
    }
    
    //MARK: - SettingSwitchCellDelegate
    func cellSwitchValueChange(_ value: Bool, cell: SettingSwitchCell) {
        let model:LiveSettingModel? = cell.cellModel
        if let model = model {
            RoomManager.shared.deviceService.setLiveDeviceStatus(model.selectionType, enable: value)
        }
    }
}
