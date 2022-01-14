//
//  FaceBeaytifyView.swift
//  ZEGOLiveDemo
//
//  Created by Larry on 2021/12/30.
//

import UIKit

enum FaceBeautifySelectedType {
    case faceBeautification
    case faceShapeRetouch
}

protocol FaceBeautifyViewDelegate : AnyObject {
    func beautifyValueChange(_ beautifyModel: FaceBeautifyModel)
}

class FaceBeautifyView: UIView {
    weak var delegate: FaceBeautifyViewDelegate?
    
    @IBOutlet weak var backgroudView: UIView! {
        didSet {
            let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: backgroudView.bounds.size.height), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
            let maskLayer: CAShapeLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            backgroudView.layer.mask = maskLayer
        }
    }
    
    @IBOutlet weak var beautyButton: UIButton! {
        didSet {
            self.beautyButton.setTitleColor(UIColor.white, for: .selected)
            self.beautyButton.setTitleColor(ZegoColor("FFFFFF_69"), for: .normal)
            self.beautyButton.setTitle(ZGLocalizedString("room_beautify_page_face_beautification"), for: .normal)
        }
    }
    @IBOutlet weak var reshapeButton: UIButton!{
        didSet {
            self.reshapeButton.setTitleColor(UIColor.white, for: .selected)
            self.reshapeButton.setTitleColor(ZegoColor("FFFFFF_69"), for: .normal)
            self.reshapeButton.setTitle(ZGLocalizedString("room_beautify_page_face_shape_retouch"), for: .normal)
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
    
    private var _faceBeatificationArray: [FaceBeautifyModel] {
        let beatifyArray = [["type": FaceBeautifyType.SkinToneEnhancement ,"value": 50, "imageName": "face_beautify_skin_tone_enhancement", "name": "room_beautify_page_skin_tone_enhancement"],
                            ["type": FaceBeautifyType.SkinSmoothing ,"value": 50, "imageName": "face_beautify_skin_smoothing", "name": "room_beautify_page_skin_smoothing"],
                            ["type": FaceBeautifyType.ImageSharpening ,"value": 50, "imageName": "face_beautify_image_sharpening", "name": "room_beautify_page_image_sharpening"],
                            ["type": FaceBeautifyType.CheekBlusher ,"value": 5, "imageName": "face_beautify_cheek_blusher", "name": "room_beautify_page_cheek_blusher"]]
        return beatifyArray.map{ FaceBeautifyModel(json: $0) }
    }
    lazy var faceBeatificationArray: [FaceBeautifyModel] = {
        return _faceBeatificationArray
    }()
    
    private var _faceShapeRetouchArray: [FaceBeautifyModel] {
        let beatifyArray = [["type": FaceBeautifyType.EyesEnlarging ,"value": 50, "imageName": "face_beautify_eyes_enlarging", "name": "room_beautify_page_eyes_enlarging"],
                            ["type": FaceBeautifyType.FaceSliming ,"value": 50, "imageName": "face_beautify_face_sliming", "name": "room_beautify_page_face_sliming"],
                            ["type": FaceBeautifyType.MouthShapeAdjustment ,"value": 0, "imageName": "face_beautify_mouth_shape_adjustment", "name": "room_beautify_page_mouth_shape_adjustment"],
                            ["type": FaceBeautifyType.EyesBrightening ,"value": 50, "imageName": "face_beautify_eyes_brightening", "name": "room_beautify_page_eyes_brightening"],
                            ["type": FaceBeautifyType.NoseSliming ,"value": 50, "imageName": "face_beautify_nose_sliming", "name": "room_beautify_page_nose_sliming"],
                            ["type": FaceBeautifyType.TeethWhitening ,"value": 50, "imageName": "face_beautify_teeth_whitening", "name": "room_beautify_page_teeth_whitening"],
                            ["type": FaceBeautifyType.ChinLengthening ,"value": 0, "imageName": "face_beautify_chin_lengthening", "name": "room_beautify_page_chin_lengthening"]]
        return beatifyArray.map{ FaceBeautifyModel(json: $0) }
    }
    lazy var faceShapeRetouchArray: [FaceBeautifyModel] = {
        return _faceShapeRetouchArray
    }()
    
    var selectedType = FaceBeautifySelectedType.faceBeautification
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
        let h = 76.0
        let y = bounds.size.height - backgroudView.bounds.size.height - h
        slider.frame = CGRect(x: x, y: y, width: w, height: h)
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
        self.reshapeButton.isSelected = false
        
        self.beautyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        self.reshapeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        self.selectedType = FaceBeautifySelectedType.faceBeautification
        self.beautifyCollectionView.reloadData()
    }
    
    @IBAction func pressReshapeButton(_ sender: UIButton) {
        self.slider.isHidden = true
        self.beautyButton.isSelected = false
        self.reshapeButton.isSelected = true
        self.selectedType = FaceBeautifySelectedType.faceShapeRetouch
        self.beautyButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        self.reshapeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        self.beautifyCollectionView.reloadData()
    }
    
    @IBAction func pressResetButton(_ sender: UIButton) {
        
        if selectedType == .faceBeautification {
            resetFaceBeatification()
        } else {
            resetFaceShapeRetouch()
        }
        
        self.slider.isHidden = true
        
        if let index = beautifyCollectionView.indexPathsForSelectedItems?.first {
            beautifyCollectionView.deselectItem(at: index, animated: true)
        }
    }
}

// MARK: private method
extension FaceBeautifyView {
    func resetFaceBeatification() {
        faceBeatificationArray = _faceBeatificationArray
        for item in faceBeatificationArray {
            delegate?.beautifyValueChange(item)
        }
    }
    
    func resetFaceShapeRetouch() {
        faceShapeRetouchArray = _faceShapeRetouchArray
        for item in faceShapeRetouchArray {
            delegate?.beautifyValueChange(item)
        }
    }
}

extension FaceBeautifyView : ZegoSliderDelegate {
    func slider(_ slider: ZegoSlider, valueDidChange value: Float) {
        guard let selectedModel = selectedFaceBeautifyModel else { return }
        selectedModel.value = Int(value)
        delegate?.beautifyValueChange(selectedModel)
    }
}

extension FaceBeautifyView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedType == FaceBeautifySelectedType.faceBeautification {
            return self.faceBeatificationArray.count
        } else {
            return self.faceShapeRetouchArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FaceBeautifyColletionViewCell", for: indexPath) as? FaceBeautifyColletionViewCell else {
            return FaceBeautifyColletionViewCell()
        }
        var modelArray = self.faceBeatificationArray
        if selectedType == FaceBeautifySelectedType.faceShapeRetouch {
            modelArray = self.faceShapeRetouchArray
        }
        let model = modelArray[indexPath.row]
        cell.updateCellWithModel(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedType == FaceBeautifySelectedType.faceBeautification {
            selectedFaceBeautifyModel = self.faceBeatificationArray[indexPath.row]
        } else {
            selectedFaceBeautifyModel = self.faceShapeRetouchArray[indexPath.row]
        }
        self.slider.isHidden = false
        if selectedFaceBeautifyModel?.type == .ChinLengthening {
            self.slider.setSliderValue(selectedFaceBeautifyModel?.value ?? 0, min: -100, max: 100)
        } else {
            self.slider.setSliderValue(selectedFaceBeautifyModel?.value ?? 0, min: 0, max: 100)
        }
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
        return UIEdgeInsets(top: 0, left: 17.5, bottom: 0, right: 17.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 68)
    }
}
