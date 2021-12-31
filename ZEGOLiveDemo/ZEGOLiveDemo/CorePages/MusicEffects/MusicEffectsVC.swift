//
//  MusicEffectsVC.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2021/12/30.
//

import UIKit

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
