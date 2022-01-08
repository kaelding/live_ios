//
//  LiveSettingView.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/5.
//

import UIKit
import ZegoExpressEngine

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
        clipRoundCorners()
    }
    
    func clipRoundCorners() -> Void {
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: roundView.bounds.size.width, height: roundView.bounds.size.height), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = roundView.bounds
        maskLayer.path = maskPath.cgPath
        roundView.layer.mask = maskLayer
    }
    
    func setViewType(_ type: LiveSettingViewType)  {
        viewType = type
        if type == .nomal {
            containerViewHeight.constant = 564
            settingDataSource = [["title": ZGLocalizedString("room_settings_page_codec") ,"subTitle": "H.264", "selectionType": SettingSelectionType.encoding, "switchStatus": false],
                                 ["title": ZGLocalizedString("room_settings_page_layered_coding") ,"subTitle": "", "selectionType": SettingSelectionType.layered, "switchStatus": RoomManager.shared.deviceService.layerCoding],
                                 ["title": ZGLocalizedString("room_settings_page_hardware_encoding"), "subTitle": "", "selectionType": SettingSelectionType.hardware, "switchStatus": RoomManager.shared.deviceService.hardwareCoding],
                                 ["title": ZGLocalizedString("room_settings_page_hardware_decoding"), "subTitle": "", "selectionType": SettingSelectionType.decoding, "switchStatus": RoomManager.shared.deviceService.hardwareDecoding],
                                 ["title": ZGLocalizedString("room_settings_page_noise_suppression") ,"subTitle": "", "selectionType": SettingSelectionType.noise, "switchStatus": RoomManager.shared.deviceService.noiseRedution],
                                 ["title": ZGLocalizedString("room_settings_page_echo_cancellation"), "subTitle": "", "selectionType": SettingSelectionType.echo, "switchStatus": RoomManager.shared.deviceService.echo],
                                 ["title": ZGLocalizedString("room_settings_page_mic_volume"), "subTitle": "", "selectionType": SettingSelectionType.volume, "switchStatus": RoomManager.shared.deviceService.micVolume],
                                 ["title": ZGLocalizedString("room_settings_page_frame_rate"), "subTitle": "1080x1920", "selectionType": SettingSelectionType.resolution, "switchStatus": false],
                                 ["title": ZGLocalizedString("room_settings_page_audio_bitrate") ,"subTitle": "48kbps", "selectionType": SettingSelectionType.bitrate, "switchStatus": false]].map{ LiveSettingModel(json: $0) }
        } else if type == .less {
            containerViewHeight.constant = 201
            settingDataSource = [["title": ZGLocalizedString("room_settings_page_frame_rate"), "subTitle": "1080x1920", "selectionType": SettingSelectionType.resolution, "switchStatus": false],
                                 ["title": ZGLocalizedString("room_settings_page_audio_bitrate") ,"subTitle": "48kbps", "selectionType": SettingSelectionType.bitrate, "switchStatus": false]].map{ LiveSettingModel(json: $0) }
        }
        settingTableView.reloadData()
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
            case .bitrate:
                model.subTitle = bitrateDic[RoomManager.shared.deviceService.audioBitrate]
            }
        }
        if let settingTableView = settingTableView {
            settingTableView.reloadData()
        }
    }
    
    func updateDeviceConfig() {
        if RoomManager.shared.deviceService.videoCodeID == .h264 {
            RoomManager.shared.deviceService.hardwareCoding = true
        } else if RoomManager.shared.deviceService.videoCodeID == .h265 {
            if !ZegoExpressEngine.shared().isVideoEncoderSupported(.IDH265) {
                RoomManager.shared.deviceService.setVideoCodeID(.h264)
                HUDHelper.showMessage(message: ZGLocalizedString("toast_room_page_settings_device_not_support_h265"))
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
            delegate?.settingViewDidSelected(model, type: viewType)
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
            if model.selectionType == .layered && RoomManager.shared.deviceService.videoCodeID == .h265{
                return
            }
            if model.selectionType == .hardware && RoomManager.shared.deviceService.videoCodeID == .h265 && !value {
                model.switchStatus = true
                HUDHelper.showMessage(message: ZGLocalizedString("toast_room_page_settings_h265_error"))
                settingTableView.reloadData()
                return
            }
            switch model.selectionType {
            case .encoding, .resolution, .bitrate:
                delegate?.settingViewDidSelected(model, type: viewType)
            case .layered, .hardware, .decoding, .noise, .echo, .volume:
                RoomManager.shared.deviceService.setLiveDeviceStatus(model.selectionType, enable: value)
                model.switchStatus = value
            }
        }
    }
}
