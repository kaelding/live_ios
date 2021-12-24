//
//  ZegoColor.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/24.
//

import Foundation
import UIKit

/// get color with name in Assets
func ZegoColor(_ name: String) -> UIColor {
    guard let color = UIColor(named: name) else {
        return UIColor.white
    }
    return color
}
