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
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configUI()
    }

    func configUI() {
        
        moreButton.layer.cornerRadius = 8.0
        moreButton.clipsToBounds = true
        signUpButton.layer.cornerRadius = 8.0
        signUpButton.clipsToBounds = true
        contactButton.layer.cornerRadius = 8.0
        contactButton.clipsToBounds = true
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
    
    
}

