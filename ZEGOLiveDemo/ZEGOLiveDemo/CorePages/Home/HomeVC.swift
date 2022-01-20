//
//  ViewController.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/23.
//

import UIKit

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = ZGLocalizedString("welcome_page_live_description")
        }
    }
    
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.layer.cornerRadius = 8.0
            moreButton.clipsToBounds = true
            moreButton.setTitle(ZGLocalizedString("welcome_page_get_more"), for: .normal)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 8.0
            signUpButton.clipsToBounds = true
            signUpButton.setTitle(ZGLocalizedString("welcome_page_sign_up"), for: .normal)
        }
    }
    
    @IBOutlet weak var contactButton: UIButton! {
        didSet {
            contactButton.layer.cornerRadius = 8.0
            contactButton.clipsToBounds = true
            contactButton.setTitle(ZGLocalizedString("welcome_page_contact_us"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // MARK: - Action
    
    @IBAction func moreButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpButtonClick(_ sender: UIButton) {
        
    }
    
    @IBAction func contactButtonClick(_ sender: UIButton) {
        
    }
}

extension HomeVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? WebVC else { return }
        if segue.identifier == "pushToMore" {
            vc.urlStr = "https://www.zegocloud.com/"
        } else if segue.identifier == "pushToContact" {
            vc.urlStr = "https://global.zegocloud.com/contact"
        } else if segue.identifier == "pushToSignup" {
            vc.urlStr = "https://www.zegocloud.com/account/signup"
        }
    }
}

