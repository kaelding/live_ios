//
//  TipView.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/7.
//

import UIKit

enum TipViewType: Int {
    case warn
    case tip
}

class TipView: UIView {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var viewType: TipViewType = .warn
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setTipViewType(_ type: TipViewType, message: String) {
        
        viewType = type
        
        switch type {
        case .warn:
            backGroundView.backgroundColor = ZegoColor("BD5454")
        case .tip:
            backGroundView.backgroundColor = ZegoColor("55BC9E")
        }
        
        messageLabel.text = message
    }
    
    func show()  {
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70)
        getKeyWindow().addSubview(self)
        if viewType == .warn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.dismiss()
            }
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }

}
