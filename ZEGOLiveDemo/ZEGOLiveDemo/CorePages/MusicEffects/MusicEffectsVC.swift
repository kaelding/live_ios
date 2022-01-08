//
//  MusicEffectsVC.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2021/12/30.
//

import UIKit
import ZegoExpressEngine


class MusicEffectsVC: UIViewController {
    
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var backGroundLabel: UILabel!
    @IBOutlet weak var bgmCollection: UICollectionView!
    
    @IBOutlet weak var musicVLabel: UILabel!
    @IBOutlet weak var musicVValueLabel: UILabel!
    @IBOutlet weak var musicVSlider: UISlider!
    
    @IBOutlet weak var voiceVLabel: UILabel!
    @IBOutlet weak var voiceVValueLabel: UILabel!
    @IBOutlet weak var voiceVSlider: UISlider!
    
    
    @IBOutlet weak var soundChangeLabel: UILabel!
    @IBOutlet weak var soundChangeCollection: UICollectionView!
    
    @IBOutlet weak var mixedRingLabel: UILabel!
    @IBOutlet weak var mixedRindCollection: UICollectionView!
    
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
         lazy var backMusicArr: [MusicEffectsModel] = {
        let bgmArray = [["name": ZGLocalizedString("room_sound_page_joyful") ,"imageName": "liveShow_backMusic", "selectedImageName": "liveShow_backMusic_selected", "selectedType": UInt(0), "isSelected": false],
                            ["name": ZGLocalizedString("room_sound_page_romantic") ,"imageName": "liveShow_backMusic", "selectedImageName": "liveShow_backMusic_selected", "selectedType": UInt(1), "isSelected": false]]
        return bgmArray.map{ MusicEffectsModel(json: $0) }
    }()
    
    lazy var voiceChangeArr: [MusicEffectsModel] = {
        let voiceArray = [["name": ZGLocalizedString("room_sound_page_none") ,"imageName": "icon_music_none", "selectedImageName": "icon_music_none(1)", "selectedType": ZegoVoiceChangerPreset.none.rawValue, "isSelected": true],
                          ["name": ZGLocalizedString("room_sound_page_lolita") ,"imageName": "icon_music_lolita", "selectedImageName": "icon_music_lolita(1)", "selectedType": ZegoVoiceChangerPreset.womenToChild.rawValue, "isSelected": false],
                          ["name": ZGLocalizedString("room_sound_page_robot") ,"imageName": "icon_music_robot", "selectedImageName": "icon_music_robot(1)", "selectedType": ZegoVoiceChangerPreset.android.rawValue, "isSelected": false],
                          ["name": ZGLocalizedString("room_sound_page_empt") ,"imageName": "icon_music_ethereal", "selectedImageName": "icon_music_ethereal(1)", "selectedType": ZegoVoiceChangerPreset.ethereal.rawValue, "isSelected": false]]
        return voiceArray.map{ MusicEffectsModel(json: $0) }
    }()
    
    lazy var reverberArr: [MusicEffectsModel] = {
        let mixVoiceArray = [["name": ZGLocalizedString("room_sound_page_none") ,"imageName": "liveShow_origin", "selectedImageName": "", "selectedType": ZegoReverbPreset.none.rawValue , "isSelected": true],
                             ["name": ZGLocalizedString("room_sound_page_ktv") ,"imageName": "liveShow_KTV", "selectedImageName": "", "selectedType": ZegoReverbPreset.KTV.rawValue, "isSelected": false],
                             ["name": "Hall" ,"imageName": "liveShow_musicConer", "selectedImageName": "", "selectedType": ZegoReverbPreset.concertHall.rawValue, "isSelected": false],
                             ["name": ZGLocalizedString("room_sound_page_concert") ,"imageName": "liveShow_concert", "selectedImageName": "", "selectedType": ZegoReverbPreset.popular.rawValue, "isSelected": false],
                             ["name": ZGLocalizedString("room_sound_page_rock") ,"imageName": "liveShow_rock", "selectedImageName": "", "selectedType": ZegoReverbPreset.vocalConcert.rawValue, "isSelected": false]]
        return mixVoiceArray.map{ MusicEffectsModel(json: $0) }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTitleLabel.text = ZGLocalizedString("room_sound_page_sound_effects")
        backGroundLabel.text = ZGLocalizedString("room_sound_page_sound_background")
        musicVLabel.text = ZGLocalizedString("room_sound_page_music_volume")
        voiceVLabel.text = ZGLocalizedString("room_sound_page_voice_volume")
        soundChangeLabel.text = ZGLocalizedString("room_sound_page_voice_changing")
        mixedRingLabel.text = ZGLocalizedString("room_sound_page_reverb")
        
        registerCell()
        musicVValueLabel.text = "\(RoomManager.shared.soundService.musicVolume)"
        voiceVValueLabel.text = "\(RoomManager.shared.soundService.musicVolume)"
        musicVSlider.value = Float(RoomManager.shared.soundService.musicVolume) * 0.01
        musicVSlider.value = Float(RoomManager.shared.soundService.voiceVolume) * 0.01
        musicVSlider.addTarget(self, action: #selector(musicVSSliderValueChanged(_:for:)), for: .valueChanged)
        voiceVSlider.addTarget(self, action: #selector(voiceVSliderValueChanged(_:for:)), for: .valueChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        backGroundView.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        self.view.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bottomScrollView.isScrollEnabled = true
        bottomScrollView.contentSize = CGSize.init(width: self.view.bounds.size.width, height: 487.5)
        containerViewHeight.constant = 487.5
    }

    func registerCell() -> Void {
        bgmCollection.register(UINib.init(nibName: "BGMCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BGMCollectionViewCell")
        soundChangeCollection.register(UINib.init(nibName: "SoundChangeCell", bundle: nil), forCellWithReuseIdentifier: "SoundChangeCell")
        mixedRindCollection.register(UINib.init(nibName: "MixedRingCell", bundle: nil), forCellWithReuseIdentifier: "MixedRingCell")
    }
    
    @objc func musicVSSliderValueChanged(_ slider: UISlider?, for event: UIEvent?) {
        let touchEvent = event?.allTouches?.first
        switch touchEvent?.phase {
        case .began:
            print("start Draging")
        case .moved:
            if let value = slider?.value {
                let showValue: Int = Int(value * 100)
                musicVValueLabel.text = "\(showValue)"
            }
        case .ended:
            print("end Draging")
            if let value = slider?.value {
                let showValue: Int = Int(value * 100)
                RoomManager.shared.soundService.setCurrentBGMVolume(showValue)
            }
        default:
            break
        }
    }
    
    @objc func voiceVSliderValueChanged(_ slider: UISlider?, for event: UIEvent?) {
        let touchEvent = event?.allTouches?.first
        switch touchEvent?.phase {
        case .began:
            print("start Draging")
        case .moved:
            if let value = slider?.value {
                let showValue: Int = Int(value * 100)
                voiceVValueLabel.text = "\(showValue)"
            }
        case .ended:
            print("end Draging")
            if let value = slider?.value {
                let showValue: Int = Int(value * 200)
                RoomManager.shared.soundService.setVoiceVolume(showValue)
            }
        default:
            break
        }
    }
    

}
