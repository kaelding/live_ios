//
//  LiveBottomView.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/28.
//

import UIKit

protocol LiveBottomViewDelegate : AnyObject {
    
}

@IBDesignable class LiveBottomSuperView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addBottomView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.addBottomView()
    }
    
    var bottomView: LiveBottomView?
    weak var delegate: LiveBottomViewDelegate? {
        get {
            bottomView?.delegate
        }
        set {
            bottomView?.delegate = newValue
        }
    }
    func addBottomView() {
        if let bottomView = UINib(nibName: "LiveBottomView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? LiveBottomView {
            bottomView.frame = self.bounds
            self.addSubview(bottomView)
            self.bottomView = bottomView
        }
    }
}

class LiveBottomView: UIView {
    
    weak var delegate: LiveBottomViewDelegate?
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
