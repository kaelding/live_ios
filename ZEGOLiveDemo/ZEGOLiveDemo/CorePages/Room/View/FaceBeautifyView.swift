//
//  FaceBeaytifyView.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import UIKit

protocol FaceBeautifyViewDelegate : AnyObject {
    func beautifyValueChange(_ beautifyModel: FaceBeautifyModel)
}

class FaceBeautifyView: UIView {
    weak var delegate: FaceBeautifyViewDelegate?
    
    @IBOutlet weak var backgroudView: UIView!
    
    @IBOutlet weak var lineView: UIView! {
        didSet {
            lineView.layer.cornerRadius = 2.5
        }
    }
    
    @IBOutlet weak var beautyButton: UIButton! {
        didSet {
            self.beautyButton.setTitleColor(UIColor.white, for: .selected)
            self.beautyButton.setTitleColor(ZegoColor("FFFFFF_69"), for: .normal)
            self.beautyButton.setTitle(ZGLocalizedString("room_beautify_page_face_beautification"), for: .normal)
        }
    }
    
    @IBOutlet weak var beautifyCollectionView: UICollectionView! {
        didSet {
            beautifyCollectionView.backgroundColor = UIColor.clear
            beautifyCollectionView.delegate = self
            beautifyCollectionView.dataSource = self
        }
    }
    
    lazy var slider: ZegoSlider = {
        let slider = ZegoSlider()
        slider.setSliderValue(50, min: 0, max: 100)
        slider.delegate = self
        slider.isHidden = true
        addSubview(slider)
        return slider
    }()
    
    @IBOutlet weak var backgroundHeight: NSLayoutConstraint!
    
    private var _faceBeatificationArray: [FaceBeautifyModel] {
        let beatifyArray = [["type": FaceBeautifyType.SkinToneEnhancement,
                             "value": 50, "imageName": "face_beautify_skin_tone_enhancement",
                             "name": "room_beautify_page_skin_tone_enhancement"],
                            
                            ["type": FaceBeautifyType.SkinSmoothing, "value": 50,
                             "imageName": "face_beautify_skin_smoothing",
                             "name": "room_beautify_page_skin_smoothing"],
                            
                            ["type": FaceBeautifyType.ImageSharpening,
                             "value": 50, "imageName": "face_beautify_image_sharpening",
                             "name": "room_beautify_page_image_sharpening"],
                            
                            ["type": FaceBeautifyType.CheekBlusher,
                             "value": 5, "imageName": "face_beautify_cheek_blusher",
                             "name": "room_beautify_page_cheek_blusher"]]
        return beatifyArray.map{ FaceBeautifyModel(json: $0) }
    }
    lazy var faceBeatificationArray: [FaceBeautifyModel] = {
        return _faceBeatificationArray
    }()
    
    
    var selectedFaceBeautifyModel : FaceBeautifyModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        beautifyCollectionView.register(UINib(nibName: "FaceBeautifyColletionViewCell", bundle: nil), forCellWithReuseIdentifier: "FaceBeautifyColletionViewCell")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        beautifyCollectionView.register(UINib(nibName: "FaceBeautifyColletionViewCell", bundle: nil), forCellWithReuseIdentifier: "FaceBeautifyColletionViewCell")
        pressBeautyButton(self.beautyButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = bounds.size.width - 67.5 * 2
        let x = 67.5
        let h = 81.0
        let y = bounds.size.height - backgroudView.bounds.size.height - h
        slider.frame = CGRect(x: x, y: y, width: w, height: h)
        backgroundHeight.constant = 183.5 + self.safeAreaInsets.bottom
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let point = touch.location(in: backgroudView)
        let point2 = touch.location(in: slider)
        if backgroudView.point(inside: point, with: event) { return }
        if slider.point(inside: point2, with: event) { return }
        self.isHidden = true
    }
    
    // MARK: action
    @IBAction func pressBeautyButton(_ sender: UIButton) {
        self.slider.isHidden = true
        self.beautyButton.isSelected = true
        
        self.beautyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        self.beautifyCollectionView.reloadData()
    }
    
    @IBAction func pressResetButton(_ sender: UIButton) {
        
        resetFaceBeatification()
        
        self.slider.isHidden = true
        
        if let index = beautifyCollectionView.indexPathsForSelectedItems?.first {
            beautifyCollectionView.deselectItem(at: index, animated: true)
        }
    }
}

// MARK: private method
extension FaceBeautifyView {
    func resetFaceBeatification() {
        RoomManager.shared.beautifyService.resetBeauty()
        faceBeatificationArray = _faceBeatificationArray
    }
}

extension FaceBeautifyView : ZegoSliderDelegate {
    func slider(_ slider: ZegoSlider, valueDidChange value: Int) {
        guard let selectedModel = selectedFaceBeautifyModel else { return }
        selectedModel.value = value
        delegate?.beautifyValueChange(selectedModel)
    }
}

extension FaceBeautifyView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.faceBeatificationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaceBeautifyColletionViewCell", for: indexPath) as? FaceBeautifyColletionViewCell else {
            return FaceBeautifyColletionViewCell()
        }
        let modelArray = self.faceBeatificationArray
        let model = modelArray[indexPath.row]
        cell.updateCellWithModel(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFaceBeautifyModel = self.faceBeatificationArray[indexPath.row]
        self.slider.isHidden = false
        self.slider.setSliderValue(selectedFaceBeautifyModel?.value ?? 0, min: 0, max: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 11.0, bottom: 0, right: 11.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 68)
    }
}
