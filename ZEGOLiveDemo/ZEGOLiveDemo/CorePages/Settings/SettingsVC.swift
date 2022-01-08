//
//  SettingsVC.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/28.
//

import UIKit
import ZIM
import ZegoExpressEngine

class SettingsVC: UITableViewController {
    
    var dataSource: [[SettingCellModel]] {
        return [[configModel(type: .express), configModel(type: .zim)],
                [configModel(type: .shareLog)],
                [configModel(type: .logout)]];
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ZGLocalizedString("setting_page_settings")
    }
    
    func configModel(type:SettingCellType) -> SettingCellModel {
        let model : SettingCellModel = SettingCellModel()
        switch type {
        case .express:
            let version : String = ZegoExpressEngine.getVersion().components(separatedBy: "_")[0]
            model.title = "Express SDK Version"
            model.subTitle = "v\(version)"
            model.type = type
            break
        case .zim:
            model.title = "ZIM SDK Version"
            model.subTitle = "v\(ZIM.getVersion())"
            model.type = type
            break
        case .shareLog:
            model.title = "Upload Log"
            model.type = type
            break
        case .logout:
            model.title = "Log out"
            model.type = type
            break
        }
        return model
    }
    
    @IBAction func backItemClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 2 }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section][indexPath.row]
        var cell: UITableViewCell
        if indexPath.section == 2 {
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell2", for: indexPath)
            if let label = cell.contentView.subviews.first as? UILabel {
                label.text = model.title
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell1", for: indexPath)
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.subTitle
        }
        
        if model.type == .express {
            let lineView = UIView(frame: CGRect(x: 0, y: 53.5, width: view.bounds.size.width, height: 0.5))
            lineView.backgroundColor = ZegoColor("#1A1726")
            cell.contentView.addSubview(lineView)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 12.0
        } else {
            return 40.0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.section][indexPath.row]
        if model.type == .logout {
            RoomManager.shared.userService.logout()
            performSegue(withIdentifier: "popToLoginVC", sender: self)
        } else if model.type == .shareLog {
            // share log.
            HUDHelper.showNetworkLoading()
            RoomManager.shared.uploadLog { result in
                HUDHelper.hideNetworkLoading()
                switch result {
                case .success:
                    TipView.showTip(ZGLocalizedString("toast_upload_log_success"))
                    break
                case .failure(let error):
                    TipView.showWarn(String(format: ZGLocalizedString("toast_upload_log_fail"), error.code))
                    break
                }
            };
        }
    }
}
