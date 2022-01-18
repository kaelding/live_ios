//
//  MusicEffectsVC+BGM.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2021/12/31.
//

import Foundation
import UIKit
import ZegoExpressEngine

enum MusicEffectsType: Int {
    case bgm = 100
    case sound = 101
    case mix = 102
}


extension MusicEffectsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type: MusicEffectsType = MusicEffectsType(rawValue: collectionView.tag) ?? .bgm
        switch type {
        case .bgm:
            return self.backMusicArr.count
        case .sound:
            return self.voiceChangeArr.count
        case .mix:
            return self.reverberArr.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell = UICollectionViewCell()
        let type: MusicEffectsType = MusicEffectsType(rawValue: collectionView.tag) ?? .bgm
        switch type {
        case .bgm:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BGMCollectionViewCell", for: indexPath) as UICollectionViewCell
            let model = self.backMusicArr[indexPath.row]
            if let bgmCell = cell as? BGMCollectionViewCell {
                bgmCell .updateCellWithModel(model)
            }
        case .sound:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundChangeCell", for: indexPath) as UICollectionViewCell
            let model = self.voiceChangeArr[indexPath.row]
            if let soundCell = cell as? SoundChangeCell {
                soundCell.updateCellWithModel(model)
            }
        case .mix:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MixedRingCell", for: indexPath) as UICollectionViewCell
            let model = self.reverberArr[indexPath.row]
            if let mixCell = cell as? MixedRingCell {
                mixCell.updateCellWithModel(model)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = CGSize.init(width: 0, height: 0)
        let type: MusicEffectsType = MusicEffectsType(rawValue: collectionView.tag) ?? .bgm
        switch type {
        case .bgm:
            size = CGSize.init(width: 105, height: 85)
        case .sound:
            size = CGSize.init(width: 68, height: 67.5)
        case .mix:
            size = CGSize.init(width: 68, height: 67.5)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var space: CGFloat = 0
        let type: MusicEffectsType = MusicEffectsType(rawValue: collectionView.tag) ?? .bgm
        switch type {
        case .bgm:
            space = 12
        case .sound:
            space = 0
        case .mix:
            space = 0
        }
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let type: MusicEffectsType = MusicEffectsType(rawValue: collectionView.tag) ?? .bgm
        if type == .sound || type == .mix {
            return UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type: MusicEffectsType = MusicEffectsType(rawValue: collectionView.tag)!
        selectedItem(type: type, index: indexPath.row)
        collectionView.reloadData()
    }
    
    func selectedItem(type: MusicEffectsType, index: Int) -> Void {
        var newIndex = 0
        switch type {
        case .bgm:
            for model in self.backMusicArr {
                if index == newIndex {
                    model.isSelected = !model.isSelected
                    if !model.isSelected {
                        RoomManager.shared.soundService.stopBGM()
                    } else {
                        RoomManager.shared.soundService.loadBGM(withFilePath: model.path)
                    }
                } else {
                    model.isSelected = false
                }
                newIndex += 1
            }
        case .sound:
            for model in self.voiceChangeArr {
                if index == newIndex {
                    model.isSelected = true
                    RoomManager.shared.soundService.setVoiceChangeType(ZegoVoiceChangerPreset(rawValue: model.selectedType) ?? .none)
                } else {
                    model.isSelected = false
                }
                newIndex += 1
            }
        case .mix:
            for model in self.reverberArr {
                if index == newIndex {
                    model.isSelected = true
                    RoomManager.shared.soundService.setReverbPreset(ZegoReverbPreset(rawValue: model.selectedType) ?? .none)
                } else {
                    model.isSelected = false
                }
                newIndex += 1
            }
        }
    }

}
