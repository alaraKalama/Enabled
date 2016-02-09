//
//  WebViewViewController.swift
//  Enabled
//
//  Created by Bianka on 2/8/16.
//  Copyright © 2016 MogaSam. All rights reserved.
//

import UIKit

class WebViewViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: "https://mogasam.wordpress.com/about/");
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
    }
}
