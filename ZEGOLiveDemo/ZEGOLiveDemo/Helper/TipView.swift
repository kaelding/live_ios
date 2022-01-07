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
    var autoDismiss: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    static func showTipView(_ type: TipViewType, message: String, autoDismiss: Bool = false) -> TipView {
        let tipView: TipView = UINib(nibName: "TipView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! TipView
        tipView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70)
        tipView.autoDismiss = autoDismiss
        switch type {
        case .warn:
            tipView.backGroundView.backgroundColor = ZegoColor("BD5454")
        case .tip:
            tipView.backGroundView.backgroundColor = ZegoColor("55BC9E")
        }
        tipView.messageLabel.text = message
        tipView.show()
        return tipView
    }
    
    func show()  {
        getKeyWindow().addSubview(self)
        if autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                TipView.dismiss()
            }
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            for subview in KeyWindow().subviews {
                if subview is TipView {
                    let view: TipView = subview as! TipView
                    view.removeFromSuperview()
                }
            }
        }
    }

}
