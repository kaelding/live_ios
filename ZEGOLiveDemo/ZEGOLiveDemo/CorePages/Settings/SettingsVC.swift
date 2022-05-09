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
    
    lazy var dataSource: [[SettingCellModel]] = {
        return [[configModel(type: .express), configModel(type: .zim), configModel(type: .app)],
                [configModel(type: .terms), configModel(type: .privacy)],
                [configModel(type: .shareLog)],
                [configModel(type: .logout)]];
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ZGLocalizedString("setting_page_settings")
    }
    
    func configModel(type:SettingCellType) -> SettingCellModel {
        let model : SettingCellModel = SettingCellModel()
        model.type = type
        switch type {
        case .express:
            model.title = ZGLocalizedString("setting_page_sdk_version")
            model.subTitle = ZegoExpressEngine.getVersion()
        case .zim:
            model.title = ZGLocalizedString("setting_page_zim_sdk_version")
            model.subTitle = ZIM.getVersion()
        case .shareLog:
            model.title = ZGLocalizedString("setting_page_upload_log")
        case .logout:
            model.title = ZGLocalizedString("setting_page_logout")
        case .app:
            model.title = ZGLocalizedString("setting_page_version")
            model.subTitle = getAppVersion()
        case .terms:
            model.title = ZGLocalizedString("setting_page_terms_of_service")
        case .privacy:
            model.title = ZGLocalizedString("setting_page_privacy_policy")
        }
        return model
    }
    
    @IBAction func backItemClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = dataSource[section]
        return arr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section][indexPath.row]
        var cell: UITableViewCell
        if model.type == .logout {
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell2", for: indexPath)
            if let label = cell.contentView.subviews.first as? UILabel {
                label.text = model.title
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell1", for: indexPath)
            cell.textLabel?.text = model.title
            cell.detailTextLabel?.text = model.subTitle
        }
        
        if model.type == .express || model.type == .zim || model.type == .terms {
            let lineView = UIView(frame: CGRect(x: 0, y: 53.5, width: view.bounds.size.width, height: 0.5))
            lineView.backgroundColor = ZegoColor("#1A1726")
            cell.contentView.addSubview(lineView)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 {
            return 40.0
        } else {
            return 12.0
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
        } else if model.type == .terms {
            junmpToWeb("https://www.zegocloud.com/policy?index=1")
        } else if model.type == .privacy {
            junmpToWeb("https://www.zegocloud.com/policy?index=0")
        }
    }
}

extension SettingsVC {
    private func getAppVersion() -> String {
        let bundle = Bundle.main
        let localVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        let version = (localVersion ?? "") + "." + (build ?? "")
        return version
    }
    private func junmpToWeb(_ urlStr: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebVC") as! WebVC
        vc.urlStr = urlStr
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
