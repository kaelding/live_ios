//
//  WebVC.swift
//  ZEGOLiveDemo
//
//  Created by Kael Ding on 2022/1/10.
//

import UIKit
import WebKit

class WebVC: UIViewController {

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.uiDelegate = self
            webView.navigationDelegate = self
        }
    }
    
    var urlStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let urlStr = urlStr,
           let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    @IBAction func backItemClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension WebVC : WKUIDelegate, WKNavigationDelegate {
    
}
