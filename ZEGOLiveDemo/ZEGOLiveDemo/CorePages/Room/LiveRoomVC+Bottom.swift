//
//  LiveRoomVC+Bottom.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/29.
//

import Foundation

extension LiveRoomVC : LiveBottomViewDelegate {
    
    func liveBottomView(_ bottomView: LiveBottomView, didClickButtonWith action: LiveBottomAction) {
        print("liveBottomView did click button: \(action)")
        switch action {
        case .message:
            return
        case .share:
            return
        case .beauty:
            return
        case .soundEffect:
            let vc: MusicEffectsVC = MusicEffectsVC(nibName :"MusicEffectsVC",bundle : nil)
            vc.view.frame = CGRect.init(x: 0, y: self.view.bounds.size.height - 385, width: self.view.bounds.size.width, height: 385)
//            vc.view.isHidden = true
            self.addChild(vc)
            self.view.addSubview(vc.view)
        case .more:
            return
        case .apply:
            return
        case .flip:
            return
        case .camera:
            return
        case .mic:
            return
        case .end:
            return
        }
    }
}
