//
//  MusicEffectsVC.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2021/12/30.
//

import UIKit
import ZegoExpressEngine


class MusicEffectsVC: UIViewController {
    
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
    
    
    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
    lazy var backMusicArr: [MusicEffectsModel] = {
        let bgmArray = [["name": "Joyful" ,"imageName": "liveShow_backMusic", "selectedImageName": "liveShow_backMusic_selected", "selectedType": 0, "isSelected": true],
                            ["name": "Romantic" ,"imageName": "liveShow_backMusic", "selectedImageName": "liveShow_backMusic_selected", "selectedType": 1, "isSelected": false],
                            ["name": "Positive" ,"imageName": "liveShow_backMusic", "selectedImageName": "liveShow_backMusic_selected", "selectedType": 2, "isSelected": false]]
        return bgmArray.map{ MusicEffectsModel(json: $0) }
    }()
    
    lazy var voiceChangeArr: [MusicEffectsModel] = {
        let voiceArray = [["name": "None" ,"imageName": "icon_music_none", "selectedImageName": "icon_music_none(1)", "selectedType": ZegoVoiceChangerPreset.none, "isSelected": true],
                          ["name": "Lolita" ,"imageName": "icon_music_lolita", "selectedImageName": "icon_music_lolita(1)", "selectedType": ZegoVoiceChangerPreset.womenToChild, "isSelected": false],
                          ["name": "uncle" ,"imageName": "icon_music_uncle", "selectedImageName": "icon_music_uncle(1)", "selectedType": ZegoVoiceChangerPreset.foreigner, "isSelected": false],
                          ["name": "Robot" ,"imageName": "icon_music_robot", "selectedImageName": "icon_music_robot(1)", "selectedType": ZegoVoiceChangerPreset.android, "isSelected": false],
                          ["name": "Empty" ,"imageName": "icon_music_ethereal", "selectedImageName": "icon_music_ethereal(1)", "selectedType": ZegoVoiceChangerPreset.ethereal, "isSelected": false]]
        return voiceArray.map{ MusicEffectsModel(json: $0) }
    }()
    
    lazy var reverberArr: [MusicEffectsModel] = {
        let mixVoiceArray = [["name": "None" ,"imageName": "liveShow_origin", "selectedImageName": "", "selectedType": ZegoReverbPreset.none , "isSelected": true],
                             ["name": "KTV" ,"imageName": "liveShow_KTV", "selectedImageName": "", "selectedType": ZegoReverbPreset.KTV, "isSelected": false],
                             ["name": "Hall" ,"imageName": "liveShow_musicConer", "selectedImageName": "", "selectedType": ZegoReverbPreset.concertHall, "isSelected": false],
                             ["name": "Concert" ,"imageName": "liveShow_concert", "selectedImageName": "", "selectedType": ZegoReverbPreset.popular, "isSelected": false],
                             ["name": "Rock" ,"imageName": "liveShow_rock", "selectedImageName": "", "selectedType": ZegoReverbPreset.vocalConcert, "isSelected": false]]
        return mixVoiceArray.map{ MusicEffectsModel(json: $0) }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        musicVSlider.addTarget(self, action: #selector(musicVSSliderValueChanged(_:for:)), for: .valueChanged)
        voiceVSlider.addTarget(self, action: #selector(voiceVSliderValueChanged(_:for:)), for: .valueChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.view.addGestureRecognizer(tap)
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
                let showValue: Int = Int(value * 100)
                RoomManager.shared.soundService.setVoiceVolume(showValue)
            }
        default:
            break
        }
    }
    

}
