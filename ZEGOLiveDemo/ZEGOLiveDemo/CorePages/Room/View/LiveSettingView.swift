//
//  LiveSettingView.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/5.
//

import UIKit

enum LiveSettingViewType: Int {
    case nomal
    case less
}

protocol LiveSettingViewDelegate: AnyObject {
    func settingViewDidSelected(_ model: LiveSettingModel, type: LiveSettingViewType)
}

class LiveSettingView: UIView, UITableViewDelegate, UITableViewDataSource, SettingSwitchCellDelegate {

    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    weak var delegate: LiveSettingViewDelegate?
    var viewType: LiveSettingViewType = .nomal
    
    var settingDataSource: [LiveSettingModel] = []
    
    lazy var resolutionDic: [ZegoVideoResolution:String] = {
        let dic: [ZegoVideoResolution:String] = [ZegoVideoResolution.p1080:"1920x1080",
                                                ZegoVideoResolution.p720:"720x1280",
                                                ZegoVideoResolution.p540:"540x960",
                                                ZegoVideoResolution.p360:"360x640",
                                                ZegoVideoResolution.p270:"270x480",
                                                ZegoVideoResolution.p180:"182x320"]
        return dic
    }()
    
    lazy var bitrateDic: [ZegoAudioBitrate:String] = {
        let dic: [ZegoAudioBitrate:String] = [ZegoAudioBitrate.b48 : "48kbps",
                                             ZegoAudioBitrate.b96 : "56kbps",
                                             ZegoAudioBitrate.b128:"128kbps"]
        return dic
    }()
    
    override var isHidden: Bool {
        didSet {
            if isHidden == false {
                updateUI()
            }
        }
    }
    
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
        
        settingLabel.text = ZGLocalizedString("room_settings_page_settings")
        
        updateUI()
        
        let tapClick: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        backGroundView.addGestureRecognizer(tapClick)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if viewType == .nomal {
            containerViewHeight.constant = 385 + self.safeAreaInsets.bottom
        } else {
            containerViewHeight.constant = 206 + self.safeAreaInsets.bottom
        }
    }
    
    func setViewType(_ type: LiveSettingViewType)  {
        viewType = type
        if type == .nomal {
            containerViewHeight.constant = 385
            settingDataSource = [["title": ZGLocalizedString("room_settings_page_codec"),
                                  "subTitle": "H.264", "selectionType": ZegoDevicesType.encoding,
                                  "switchStatus": false],
                                 
                                 ["title": ZGLocalizedString("room_settings_page_layered_coding"),
                                  "subTitle": "", "selectionType": ZegoDevicesType.layeredCoding,
                                  "switchStatus": RoomManager.shared.deviceService.layeredCoding],
                                 
                                 ["title": ZGLocalizedString("room_settings_page_hardware_encoding"),
                                  "subTitle": "", "selectionType": ZegoDevicesType.hardwareEncoder,
                                  "switchStatus": RoomManager.shared.deviceService.hardwareCoding],
                                 
                                 ["title": ZGLocalizedString("room_settings_page_hardware_decoding"),
                                  "subTitle": "", "selectionType": ZegoDevicesType.hardwareDecoder,
                                  "switchStatus": RoomManager.shared.deviceService.hardwareDecoding],
                                 
                                 ["title": ZGLocalizedString("room_settings_page_noise_suppression"),
                                  "subTitle": "", "selectionType": ZegoDevicesType.noiseSuppression,
                                  "switchStatus": RoomManager.shared.deviceService.noiseSliming],
                                 
                                 ["title": ZGLocalizedString("room_settings_page_echo_cancellation"),
                                  "subTitle": "", "selectionType": ZegoDevicesType.echoCancellation,
                                  "switchStatus": RoomManager.shared.deviceService.echoCancellation],
                                 
                                 ["title": ZGLocalizedString("room_settings_page_mic_volume"),
                                  "subTitle": "", "selectionType": ZegoDevicesType.volumeAdjustment,
                                  "switchStatus": RoomManager.shared.deviceService.volumeAdjustment],
                                 
                                 ["title": ZGLocalizedString("room_settings_page_video_resolution"),
                                  "subTitle": "1080x1920", "selectionType": ZegoDevicesType.videoResolution,
                                  "switchStatus": false],
                                 
                                 ["title": ZGLocalizedString("room_settings_page_audio_bitrate"),
                                  "subTitle": "48kbps",
                                  "selectionType": ZegoDevicesType.bitrate,
                                  "switchStatus": false]
                                ].map{ LiveSettingModel(json: $0) }
        } else if type == .less {
            containerViewHeight.constant = 201
            settingDataSource = [["title": ZGLocalizedString("room_settings_page_video_resolution"),
                                  "subTitle": "1080x1920", "selectionType": ZegoDevicesType.videoResolution,
                                  "switchStatus": false],
                                 
                                 ["title": ZGLocalizedString("room_settings_page_audio_bitrate"),
                                  "subTitle": "48kbps", "selectionType": ZegoDevicesType.bitrate,
                                  "switchStatus": false]
                                ].map{ LiveSettingModel(json: $0) }
        }
        settingTableView.reloadData()
    }
    
    func updateUI() -> Void {
        for model in settingDataSource {
            switch model.selectionType {
            case .encoding:
                model.subTitle = RoomManager.shared.deviceService.codec == .h264 ? "H.264":"H.265"
            case .layeredCoding:
                model.switchStatus = RoomManager.shared.deviceService.layeredCoding
            case .hardwareEncoder:
                model.switchStatus = RoomManager.shared.deviceService.hardwareCoding
            case .hardwareDecoder:
                model.switchStatus = RoomManager.shared.deviceService.hardwareDecoding
            case .noiseSuppression:
                model.switchStatus = RoomManager.shared.deviceService.noiseSliming
            case .echoCancellation:
                model.switchStatus = RoomManager.shared.deviceService.echoCancellation
            case .volumeAdjustment:
                model.switchStatus = RoomManager.shared.deviceService.volumeAdjustment
            case .videoResolution:
                model.subTitle = resolutionDic[RoomManager.shared.deviceService.videoResolution]
            case .bitrate:
                model.subTitle = bitrateDic[RoomManager.shared.deviceService.bitrate]
            }
        }
        if let settingTableView = settingTableView {
            settingTableView.reloadData()
        }
    }
    
    func updateDeviceConfig() {
        if RoomManager.shared.deviceService.codec == .h264 {
            RoomManager.shared.deviceService.hardwareCoding = true
        } else if RoomManager.shared.deviceService.codec == .h265 {
            if !RoomManager.shared.deviceService.isVideoEncoderSupportedH265() {
                RoomManager.shared.deviceService.setVideoCodec(.h264)
                TipView.showTip(ZGLocalizedString("toast_room_page_settings_device_not_support_h265"))
            }
        }
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
            case .noiseSuppression, .echoCancellation, .volumeAdjustment, .layeredCoding, .hardwareEncoder, .hardwareDecoder:
                let cell: SettingSwitchCell = tableView.dequeueReusableCell(withIdentifier: "SettingSwitchCell") as! SettingSwitchCell
                cell.updateCell(model)
                cell.delegate = self
                return cell
            case .videoResolution, .bitrate, .encoding:
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
            case .noiseSuppression, .echoCancellation, .volumeAdjustment:
            break
        case .encoding, .videoResolution, .bitrate:
            delegate?.settingViewDidSelected(model, type: viewType)
        case .layeredCoding:
            break
        case .hardwareEncoder:
            break
        case .hardwareDecoder:
            break
        }
    }
    
    //MARK: - SettingSwitchCellDelegate
    func cellSwitchValueChange(_ value: Bool, cell: SettingSwitchCell) {
        let model:LiveSettingModel? = cell.cellModel
        if let model = model {
            if model.selectionType == .layeredCoding && RoomManager.shared.deviceService.codec == .h265{
                return
            }
            if model.selectionType == .hardwareEncoder && RoomManager.shared.deviceService.codec == .h265 && !value {
                model.switchStatus = true
                TipView.showTip(ZGLocalizedString("toast_room_page_settings_h265_error"))
                settingTableView.reloadData()
                return
            }
            switch model.selectionType {
            case .encoding, .videoResolution, .bitrate:
                delegate?.settingViewDidSelected(model, type: viewType)
            case .layeredCoding, .hardwareEncoder, .hardwareDecoder, .noiseSuppression, .echoCancellation, .volumeAdjustment:
                RoomManager.shared.deviceService.setDeviceStatus(model.selectionType, enable: value)
                model.switchStatus = value
            }
        }
    }
}
