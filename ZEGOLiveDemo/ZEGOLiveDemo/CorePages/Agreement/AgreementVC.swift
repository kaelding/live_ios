//
//  AgreementVC.swift
//  ZEGOLiveDemo
//
//  Created by zego on 2022/3/9.
//

import UIKit

class AgreementVC: UIViewController {
    
    let detailMessage: String = ZGLocalizedString("policy_notice_message")
    
    @IBOutlet weak var textView: UITextView! {
        didSet{
            textView.delegate = self
            let attStr = NSMutableAttributedString(string: detailMessage)
            attStr.addAttribute(NSAttributedString.Key.foregroundColor, value: ZegoColor("FFFFFF"), range: NSRange(location: 0, length: detailMessage.count))
            attStr.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: detailMessage.count))
             //点击超链接
             attStr.addAttribute(NSAttributedString.Key.link, value: "userProtocol://", range: (detailMessage as NSString).range(of: ZGLocalizedString("policy_privacy_name")))
             //点击超链接
            attStr.addAttribute(NSAttributedString.Key.link, value: "privacyPolicy://", range: (detailMessage as NSString).range(of: ZGLocalizedString("terms_of_service")))
            textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: ZegoColor("A653FF")]
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 8
            attStr.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: detailMessage.count))
            textView.attributedText = attStr
        }
    }
    
    @IBOutlet weak var agreeButton: UIButton! {
        didSet {
            agreeButton.setTitle(ZGLocalizedString("policy_notice_Agree"), for: .normal)
            let layer = CAGradientLayer()
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
            layer.locations = [NSNumber(value: 0.5), NSNumber(value: 1.0)]
            let startColor = ZegoColor("A754FF")
            let endColor = ZegoColor("510DF1")
            layer.colors = [startColor.cgColor, endColor.cgColor]
            layer.frame = agreeButton.bounds
            agreeButton.layer.addSublayer(layer)
        }
    }
    
    @IBOutlet weak var disagreeButton: UIButton! {
        didSet {
            disagreeButton.setTitle(ZGLocalizedString("policy_notice_Disagree"), for: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = ZGLocalizedString("policy_notice_name")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func disAgreement(_ sender: Any) {
        showSureAlter()
    }
    
    @IBAction func agreeClick(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: ProcyAgreeStatus)
        self.dismiss(animated: true, completion: nil)
    }
    
    func showSureAlter() {
        let title = ZGLocalizedString("policy_notice_alter_title")
        let message = ZGLocalizedString("policy_notice_alter_message")
        let sureAlter = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: ZGLocalizedString("policy_notice_alter_quit"), style: .cancel) { action in
            UserDefaults.standard.set(false, forKey: ProcyAgreeStatus)
            abort()
        }
        let okAction = UIAlertAction(title: ZGLocalizedString("policy_notice_alter_agree"), style: .default)
        { [weak self] action in
            UserDefaults.standard.set(true, forKey: ProcyAgreeStatus)
            self?.dismiss(animated: true, completion: nil)
        }
        sureAlter.addAction(okAction)
        sureAlter.addAction(cancelAction)
        self.present(sureAlter, animated: true, completion: nil)
    }
}

extension AgreementVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme  ==  "userProtocol"{
            junmpToWeb("https://www.zegocloud.com/policy?index=0")
            return false
        }else if URL.scheme == "privacyPolicy"{
            junmpToWeb("https://www.zegocloud.com/policy?index=1")
            return false
        }
        return true
    }
    
    private func junmpToWeb(_ urlStr: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebVC") as! WebVC
        vc.urlStr = urlStr
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
