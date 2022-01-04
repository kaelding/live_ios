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
            let maskPath: UIBezierPath = UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: backgroudView.bounds.size.width, height: backgroudView.bounds.size.height), byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize.init(width: 16, height: 16))
            let maskLayer: CAShapeLayer = CAShapeLayer()
            maskLayer.frame = backgroudView.bounds
            maskLayer.path = maskPath.cgPath
            backgroudView.layer.mask = maskLayer
        }
    }
    @IBOutlet weak var valueSlider: UISlider! {
        didSet {
            self.valueSlider.isHidden = true
        }
    }
    @IBOutlet weak var beautyButton: UIButton! {
        didSet {
            self.beautyButton.setTitleColor(UIColor.white, for: .selected)
            self.beautyButton.setTitleColor(ZegoColor("FFFFFF_69"), for: .normal)
        }
    }
    @IBOutlet weak var reshapeButton: UIButton!{
        didSet {
            self.reshapeButton.setTitleColor(UIColor.white, for: .selected)
            self.reshapeButton.setTitleColor(ZegoColor("FFFFFF_69"), for: .normal)
        }
    }
    
    @IBOutlet weak var beautifyCollectionView: UICollectionView! {
        didSet {
            beautifyCollectionView.backgroundColor = UIColor.clear
            
            beautifyCollectionView.delegate = self
            beautifyCollectionView.dataSource = self
        }
    }
    
    var faceBeatificationArray: [FaceBeautifyModel] {
        let beatifyArray = [["type": FaceBeautifyType.SkinToneEnhancement ,"value": 0, "imageName": "face_beautify_skin_tone_enhancement", "name": "Whitening"],
                            ["type": FaceBeautifyType.SkinSmoothing ,"value": 0, "imageName": "face_beautify_skin_smoothing", "name": "Smoothing"],
                            ["type": FaceBeautifyType.ImageSharpening ,"value": 0, "imageName": "face_beautify_image_sharpening", "name": "Sharpening"],
                            ["type": FaceBeautifyType.CheekBlusher ,"value": 0, "imageName": "face_beautify_cheek_blusher", "name": "Rudding"]]
        return beatifyArray.map{ FaceBeautifyModel(json: $0) }
    }
    
    var faceShapeRetouchArray: [FaceBeautifyModel] {
        let beatifyArray = [["type": FaceBeautifyType.EyesEnlarging ,"value": 0, "imageName": "face_beautify_eyes_enlarging", "name": "Eyes enlarging"],
                            ["type": FaceBeautifyType.FaceSliming ,"value": 0, "imageName": "face_beautify_face_sliming", "name": "Face sliming"],
                            ["type": FaceBeautifyType.MouthShapeAdjustment ,"value": 0, "imageName": "face_beautify_mouth_shape_adjustment", "name": "Mouth shape adjustment"],
                            ["type": FaceBeautifyType.EyesBrightening ,"value": 0, "imageName": "face_beautify_eyes_brightening", "name": "Eyes brightening"],
                            ["type": FaceBeautifyType.NoseSliming ,"value": 0, "imageName": "face_beautify_nose_sliming", "name": "Rudding"],
                            ["type": FaceBeautifyType.ChinLengthening ,"value": 0, "imageName": "face_beautify_chin_lengthening", "name": "Rudding"],
                            ["type": FaceBeautifyType.TeethWhitening ,"value": 0, "imageName": "face_beautify_teeth_whitening", "name": "Teeth whitening"]]
        return beatifyArray.map{ FaceBeautifyModel(json: $0) }
    }
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
    }
    
    // MARK: action
    @IBAction func pressBeautyButton(_ sender: UIButton) {
        self.beautyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        self.reshapeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        self.selectedType = FaceBeautifySelectedType.faceBeautification
        self.beautifyCollectionView.reloadData()
    }
    
    @IBAction func pressReshapeButton(_ sender: UIButton) {
        self.selectedType = FaceBeautifySelectedType.faceShapeRetouch
        self.beautyButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        self.reshapeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        self.beautifyCollectionView.reloadData()
    }
    
    @IBAction func pressResetButton(_ sender: UIButton) {
        let array = selectedType == .faceBeautification ? self.faceBeatificationArray : self.faceShapeRetouchArray
        for item in array {
            item.value = 0
            delegate?.beautifyValueChange(item)
        }
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        guard let selectedModel = selectedFaceBeautifyModel else { return }
        selectedModel.value = Int32(sender.value)
        delegate?.beautifyValueChange(selectedModel)
    }
    
    
    // MARK: private method
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
        var selectedModel = selectedFaceBeautifyModel
        if selectedType == FaceBeautifySelectedType.faceBeautification {
            selectedModel = self.faceBeatificationArray[indexPath.row]
        } else {
            selectedModel = self.faceShapeRetouchArray[indexPath.row]
        }
        if selectedFaceBeautifyModel?.type == selectedModel?.type {
            selectedFaceBeautifyModel = nil
            self.valueSlider.isHidden = true
        } else {
            selectedFaceBeautifyModel = selectedModel
            self.valueSlider.isHidden = false
            self.valueSlider.value = Float(selectedModel?.value ?? 0)
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
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66, height: 68)
    }
}
