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
        let bgmArray = [["name": "欢快" ,"imageName": "liveShow_backMusic", "selectedImageName": "liveShow_backMusic_selected", "selectedType": 0, "isSelected": true],
                            ["name": "浪漫" ,"imageName": "liveShow_backMusic", "selectedImageName": "liveShow_backMusic_selected", "selectedType": 1, "isSelected": false],
                            ["name": "正能量" ,"imageName": "liveShow_backMusic", "selectedImageName": "liveShow_backMusic_selected", "selectedType": 2, "isSelected": false]]
        return bgmArray.map{ MusicEffectsModel(json: $0) }
    }()
    
    lazy var voiceChangeArr: [MusicEffectsModel] = {
        let voiceArray = [["name": "原声" ,"imageName": "icon_music_none", "selectedImageName": "icon_music_none(1)", "selectedType": ZegoVoiceChangerPreset.none, "isSelected": true],
                          ["name": "萝莉" ,"imageName": "icon_music_lolita", "selectedImageName": "icon_music_lolita(1)", "selectedType": ZegoVoiceChangerPreset.womenToChild, "isSelected": false],
                          ["name": "外国人" ,"imageName": "icon_music_uncle", "selectedImageName": "icon_music_uncle(1)", "selectedType": ZegoVoiceChangerPreset.foreigner, "isSelected": false],
                          ["name": "机器人" ,"imageName": "icon_music_robot", "selectedImageName": "icon_music_robot(1)", "selectedType": ZegoVoiceChangerPreset.android, "isSelected": false],
                          ["name": "空灵" ,"imageName": "icon_music_ethereal", "selectedImageName": "icon_music_ethereal(1)", "selectedType": ZegoVoiceChangerPreset.ethereal, "isSelected": false]]
        return voiceArray.map{ MusicEffectsModel(json: $0) }
    }()
    
    lazy var reverberArr: [MusicEffectsModel] = {
        let mixVoiceArray = [["name": "原声" ,"imageName": "liveShow_origin", "selectedImageName": "", "selectedType": ZegoReverbPreset.none , "isSelected": true],
                             ["name": "萝莉" ,"imageName": "liveShow_KTV", "selectedImageName": "", "selectedType": ZegoReverbPreset.KTV, "isSelected": false],
                             ["name": "外国人" ,"imageName": "liveShow_musicConer", "selectedImageName": "", "selectedType": ZegoReverbPreset.concertHall, "isSelected": false],
                             ["name": "机器人" ,"imageName": "liveShow_concert", "selectedImageName": "", "selectedType": ZegoReverbPreset.popular, "isSelected": false],
                             ["name": "空灵" ,"imageName": "liveShow_rock", "selectedImageName": "", "selectedType": ZegoReverbPreset.vocalConcert, "isSelected": false]]
        return mixVoiceArray.map{ MusicEffectsModel(json: $0) }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        musicVSlider.addTarget(self, action: #selector(musicVSSliderValueChanged(_:for:)), for: .valueChanged)
        voiceVSlider.addTarget(self, action: #selector(voiceVSliderValueChanged(_:for:)), for: .valueChanged)
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
            print("开始拖动")
        case .moved:
            if let value = slider?.value {
                let showValue: Int = Int(value * 100)
                musicVValueLabel.text = "\(showValue)"
            }
        case .ended:
            print("结束拖动")
        default:
            break
        }
    }
    
    @objc func voiceVSliderValueChanged(_ slider: UISlider?, for event: UIEvent?) {
        let touchEvent = event?.allTouches?.first
        switch touchEvent?.phase {
        case .began:
            print("开始拖动")
        case .moved:
            if let value = slider?.value {
                let showValue: Int = Int(value * 100)
                voiceVValueLabel.text = "\(showValue)"
            }
        case .ended:
            print("结束拖动")
        default:
            break
        }
    }
    

}
