//
//  LiveSettingView.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/1/5.
//

import UIKit

class LiveSettingView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    
    lazy var settingDataSource: [LiveSettingModel] = {
        let dataSource = [["title": "Background noise reduction" ,"subTitle": "", "selectionType": SettingSelectionType.noise, "switchStatus": false],
                          ["title": "Echo cancellation" ,"subTitle": "", "selectionType": SettingSelectionType.echo, "switchStatus": false],
                          ["title": "Mic volume auto-adjustment" ,"subTitle": "", "selectionType": SettingSelectionType.volume, "switchStatus": false],
                          ["title": "Resolution settings" ,"subTitle": "1080x1920", "selectionType": SettingSelectionType.resolution, "switchStatus": false],
                          ["title": "Audio bitrate" ,"subTitle": "48kbps", "selectionType": SettingSelectionType.bitrate, "switchStatus": false]]
        return dataSource.map{ LiveSettingModel(json: $0) }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingTableView.register(UINib.init(nibName: "SettingSwitchCell", bundle: nil), forCellReuseIdentifier: "SettingSwitchCell")
        settingTableView.register(UINib.init(nibName: "SettingParamDisplayCell", bundle: nil), forCellReuseIdentifier: "SettingParamDisplayCell")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(UINib.init(nibName: "SettingSwitchCell", bundle: nil), forCellReuseIdentifier: "SettingSwitchCell")
        settingTableView.register(UINib.init(nibName: "SettingParamDisplayCell", bundle: nil), forCellReuseIdentifier: "SettingParamDisplayCell")
        settingTableView.backgroundColor = UIColor.clear
        
        let tapClick: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        self.addGestureRecognizer(tapClick)
    }
    
    @objc func tapClick() -> Void {
        self.isHidden = true
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model: LiveSettingModel = settingDataSource[indexPath.row]
        switch model.selectionType {
            case .noise, .echo, .volume:
                let cell: SettingSwitchCell = tableView.dequeueReusableCell(withIdentifier: "SettingSwitchCell") as! SettingSwitchCell
                cell.updateCell(model)
                return cell
            case .resolution, .bitrate:
                let cell: SettingParamDisplayCell = tableView.dequeueReusableCell(withIdentifier: "SettingParamDisplayCell") as! SettingParamDisplayCell
                cell.updateCell(model)
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: LiveSettingModel = settingDataSource[indexPath.row]
        switch model.selectionType {
            case .noise, .echo, .volume:
            break
            case .resolution:
            break
            case .bitrate:
            break
        }
    }
}
