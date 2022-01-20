//
//  EffectBackgroundView.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2022/1/17.
//

import UIKit

class EffectBackgroundView: UIView {

    lazy var effectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.contentView.backgroundColor = ZegoColor("111014_90")
        return effectView
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.insertSubview(effectView, at: 0)
        
        configUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        effectView.frame = bounds
    }
    
    private func configUI() {
        
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: w, height: h), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
}
