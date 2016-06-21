//
//  FbController.swift
//  facebook-light
//
//  Created by Elshad Yarmetov on 6/19/16.
//  Copyright © 2016 Elshad Yarmetov. All rights reserved.
//

import UIKit
import WebKit

class FbController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIGestureRecognizerDelegate {
    
    var siteUrlString = "https://m.facebook.com"
    var isShowLoading = true
    
    let editUrl = UITextField()
    var webView = WKWebView()
    let buttonBack = UIButton()
    let buttonReload = UIButton()
    let buttonForward = UIButton()
    let loading = UILabel()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func loadView() {
        super.loadView()
        
        let jScript = "" // "document.body.style.backgroundColor = 'red';"
        let wkUScript = WKUserScript(source: jScript, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: false)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        let wkWebConfig = WKWebViewConfiguration();
        wkWebConfig.userContentController = wkUController;
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        wkWebConfig.preferences = preferences
        webView = WKWebView(frame: self.view.frame, configuration: wkWebConfig)
        
        self.view.addSubview(webView)
        webView.navigationDelegate = self
        webView.UIDelegate = self
        //webView.backgroundColor = UIColor(red: 93/255, green: 164/255, blue: 215/255, alpha: 1)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: self.siteUrlString)!))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 93/255, green: 164/255, blue: 215/255, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        self.view.addSubview(editUrl)
        editUrl.textColor = UIColor.whiteColor()

        self.view.addSubview(buttonBack)
        buttonBack.setTitle(" << ", forState: .Normal)
        buttonBack.addTarget(self, action: #selector(actionBack), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(buttonReload)
        buttonReload.setTitle("F5", forState: .Normal)
        buttonReload.addTarget(self, action: #selector(actionReload), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(buttonForward)
        buttonForward.setTitle(" >> ", forState: .Normal)
        buttonForward.addTarget(self, action: #selector(actionForward), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(loading)
        loading.text = "Loading..."
        loading.font = UIFont.boldSystemFontOfSize(18)
        loading.textAlignment = .Center
        loading.backgroundColor = UIColor(red: 93/255, green: 164/255, blue: 215/255, alpha: 1).colorWithAlphaComponent(0.5)
        loading.hidden = true
        loading.userInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        editUrl.frame = CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 40)
        webView.frame = CGRect(x: 0, y: 20 + 40, width: self.view.bounds.width, height: self.view.bounds.height - 60 - 40)
        buttonBack.frame = CGRect(x: 0, y: webView.bounds.height + 20 + 40 , width: 50, height: 40)
        buttonReload.frame = CGRect(x: self.view.bounds.width / 2 - 25, y: buttonBack.frame.origin.y, width: 50, height: 40)
        buttonForward.frame = CGRect(x: self.view.bounds.width - 50, y: buttonBack.frame.origin.y, width: 50, height: 40)
        loading.frame = self.view.bounds
    }
    
    
    func actionBack() {
        webView.goBack()
    }
    
    func actionReload() {
        webView.reload()
    }
    
    func actionForward() {
        webView.goForward()
    }
    
    
    
    //-----------------------
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("WkVIEW_DID_START_PROVISIONAL => begin")
        if isShowLoading {
            loading.hidden = false
        }
    }
    
    //-----------------------
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        NSLog("WkVIEW_DID_FINISHED => begin")
        if isShowLoading {
            loading.hidden = true
        }
        NSLog("WkVIEW_DID_FINISHED => end")
        editUrl.text = webView.backForwardList.currentItem?.initialURL.absoluteString
        print(webView.backForwardList.currentItem?.initialURL.absoluteString)
        print(webView.backForwardList.currentItem?.URL.absoluteString)
        print(webView.backForwardList.backList)
        
        self.webView.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
        self.webView.scrollView.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
    }
    
    //-----------------------
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("WkVIEW_DID_FAIL => begin")
        if isShowLoading {
            loading.hidden = true
        }
        
        self.webView.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
        self.webView.scrollView.backgroundColor = UIColor(red:0.11, green:0.13, blue:0.19, alpha:1)
    }
    
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let childController = FbController()
            childController.siteUrlString = (navigationAction.request.URL ?? NSURL()).absoluteString
            childController.isShowLoading = false
            self.navigationController?.pushViewController(childController, animated: true)
        }
        return nil
    }
    
    

    
    

}














