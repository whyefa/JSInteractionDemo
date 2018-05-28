//
//  WKWebController.swift
//  Demo
//
//  Created by dow-np-162 on 2018/5/3.
//  Copyright © 2018年 yefa. All rights reserved.
//

import UIKit

import WebKit
import JavaScriptCore

class WKWebController: UIViewController, WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate {

    lazy var userContentController: WKUserContentController = {
        let contentController = WKUserContentController()
        return contentController
    }()
    
    lazy var web: WKWebView = {
        let preferences = WKPreferences()
        preferences.minimumFontSize = 12
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true  // window.open()
//
        weak var weakSelf = self

        let config = WKWebViewConfiguration()
        config.processPool = WKProcessPool()
        config.preferences = preferences
        config.userContentController = userContentController
        
        let webview = WKWebView(frame: view.bounds, configuration: config)
        webview.uiDelegate = weakSelf
//        webview.navigationDelegate = self
        webview.addObserver(weakSelf!, forKeyPath: "title", options: .new, context: nil)
        webview.addObserver(weakSelf!, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webview
    }()
    
    lazy var progress: UIProgressView = {
        let p = UIProgressView(frame: CGRect(x: 0, y: topBarHeight(), width: view.frame.size.width, height: 5))
        p.progressTintColor = UIColor.orange
        return p
    }()
    
    lazy var rightItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: self , action: #selector(callJS))
        return item
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userContentController.add(self, name: "share")
        userContentController.add(self, name: "goBack")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userContentController.removeScriptMessageHandler(forName: "share")
        userContentController.removeScriptMessageHandler(forName: "goBack")
    }
    
    deinit {
        self.web.removeObserver(self, forKeyPath: "title")
        self.web.removeObserver(self, forKeyPath: "estimatedProgress")
        print("WKWebController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        let url = Bundle.main.url(forResource: "wk.html", withExtension: nil)
        let request = URLRequest(url: url!)
        web.load(request)
    }
    
    //MARK: UI
    func setSubviews() {
        view.addSubview(self.web)
        self.navigationItem.rightBarButtonItem = rightItem
        web.addSubview(progress)
    }
    
    //MARK: PRIVATE
    @objc func callJS() {
        web.evaluateJavaScript("alertText('Hello WKWebView')", completionHandler: { (res, error) in
            
        })
    }
    
    func goBack() {
        if web.canGoBack {
            web.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func share(info: Any?) {
        print("分享参数 \(String(describing: info))")
    }
    
    
    func topBarHeight() -> CGFloat {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
        return CGFloat(statusBarHeight + navigationBarHeight!)
    }
    
    //MARK: WK Script message handler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let name = message.name
        print(name)
        if name == "goBack" {
            goBack()
        } else if name == "share" {
            let body = message.body
            share(info: body)
        }
    }
    
    // alert
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "提示", message:  message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "好的", style: .default, handler: { (action) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: kvo
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            self.title = web.title
        }
        
        if keyPath == "estimatedProgress" {
            print(web.estimatedProgress)
            progress.setProgress(Float(web.estimatedProgress), animated: true)
            if web.estimatedProgress == 1.0 {
                weak var weakSelf = self
                UIView.animate(withDuration: 0.3, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    weakSelf?.progress.alpha = 0
                }, completion: nil)
            }
        }
    }
    
    

}
