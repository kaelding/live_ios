//
//  MusicEffectsVC+BGM.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2021/12/31.
//

import Foundation
import UIKit


extension MusicEffectsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell = UICollectionViewCell()
        switch collectionView.tag {
        case 100:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BGMCollectionViewCell", for: indexPath) as UICollectionViewCell
            if let bgmCell = cell as? BGMCollectionViewCell {
                bgmCell.musicNameLabel.text = "1231"
            }
        case 101:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SoundChangeCell", for: indexPath) as UICollectionViewCell
            if let soundCell = cell as? SoundChangeCell {
                soundCell.voiceNameLabel.text = "1231"
            }
        case 102:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MixedRingCell", for: indexPath) as UICollectionViewCell
            if let mixCell = cell as? MixedRingCell {
                mixCell.mixedNameLabel.text = "555"
            }
        default:
            cell = UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = CGSize.init(width: 0, height: 0)
        switch collectionView.tag {
        case 100:
            size = CGSize.init(width: 105, height: 85)
        case 101:
            size = CGSize.init(width: 44, height: 67.5)
        case 102:
            size = CGSize.init(width: 44, height: 67.5)
        default:
            size = CGSize.init(width: 0, height: 0)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var space: CGFloat = 0
        switch collectionView.tag {
        case 100:
            space = 12
        case 101:
            space = 24
        case 102:
            space = 24
        default:
            space = 0
        }
        return space
    }



}
