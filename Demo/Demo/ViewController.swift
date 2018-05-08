//
//  ViewController.swift
//  Demo
//
//  Created by dow-np-162 on 2018/5/3.
//  Copyright © 2018年 yefa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func pushWKWebView(_ sender: Any) {
        let controller = WKWebController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func pushUIWebView(_ sender: Any) {
        let controller = UIWebController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

