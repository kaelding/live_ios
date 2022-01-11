//
//  ViewController.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2021/12/23.
//

import UIKit

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton! {
        didSet {
            moreButton.layer.cornerRadius = 8.0
            moreButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.layer.cornerRadius = 8.0
            signUpButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var contactButton: UIButton! {
        didSet {
            contactButton.layer.cornerRadius = 8.0
            contactButton.clipsToBounds = true
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
            vc.urlStr = "http://192.168.100.210:8081/live-join"
        } else if segue.identifier == "pushToContact" {
            vc.urlStr = "http://192.168.100.210:8081/contact"
        }
    }
}

