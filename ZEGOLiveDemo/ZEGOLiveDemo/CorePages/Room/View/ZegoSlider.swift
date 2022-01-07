//
//  ZegoSlider.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2022/1/5.
//

import UIKit

protocol ZegoSliderDelegate: AnyObject {
    func slider(_ slider: ZegoSlider, valueDidChange value: Float)
}

class ZegoSlider: UIView {

    weak var delegate: ZegoSliderDelegate?
    
    lazy var label: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = ZegoColor("1B1A1C")
        label.textAlignment = .center
        return label
    }()

    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        slider.minimumTrackTintColor = ZegoColor("000000_30")
        slider.maximumTrackTintColor = ZegoColor("000000")
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        return slider
    }()
    
    lazy var indicatorImgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "slider_bg"))
        imageView.addSubview(label)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        self.addSubview(indicatorImgView)
        self.addSubview(slider)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorImgView.frame = CGRect(x: 0, y: 0, width: 36, height: 30.5)
        label.frame = CGRect(x: 0, y: 1.0, width: 36, height: 21)
        label.center = CGPoint(x: indicatorImgView.center.x, y: label.center.y)
        slider.frame = CGRect(x: 0, y: 50.5, width: self.bounds.width, height: 16.0)
    }
    
    // MARK: - action
    @objc func sliderValueDidChange(_ slider: UISlider?) {
        let value = slider?.value ?? 0
        label.text = String(Int(value))
        updateIndicatorView(Int(value))
        delegate?.slider(self, valueDidChange: value)
    }
    
    // MARK: - Public
    func setSliderValue(_ value: Int, min: Int, max: Int) {
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.setValue(Float(value), animated: false)
        label.text = String(value)
        
        if max - min <= 0 { return }
        updateIndicatorView(value)
    }
    
    func updateIndicatorView(_ value: Int) {
        let x: Float = -1.0 + Float((self.bounds.size.width - 31.0)) / (slider.maximumValue - slider.minimumValue) * (Float(value) - slider.minimumValue)
        indicatorImgView.frame = CGRect(x: Double(x), y: 0, width: 36, height: 30.5)
    }
}
