//
//  RoomListVC.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/27.
//

import UIKit

class RoomListVC: UIViewController {

    @IBOutlet weak var roomListCollectionView: UICollectionView!
    
    @IBOutlet weak var creatButton: UIButton! {
        didSet {
            creatButton.layer.cornerRadius = 22
            let layer = CAGradientLayer()
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
            layer.locations = [NSNumber(value: 0.5), NSNumber(value: 1.0)]
            let startColor = ZegoColor("A754FF")
            let endColor = ZegoColor("510DF1")
            layer.colors = [startColor.cgColor, endColor.cgColor]
            layer.frame = creatButton.bounds
            creatButton.layer.addSublayer(layer)
        }
    }
    
    @IBOutlet weak var emptyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
