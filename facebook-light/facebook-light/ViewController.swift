//
//  ViewController.swift
//  facebook-light
//
//  Created by Elshad Yarmetov on 6/19/16.
//  Copyright © 2016 Elshad Yarmetov. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var siteUrl = "http://lite.facebook.com"
    
    private var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.blueColor()
        
        
        let wkWebConfig = WKWebViewConfiguration()
        var jsHandler = ""
        do {
            jsHandler = try String(contentsOfURL: NSBundle.mainBundle().URLForResource("Android", withExtension: "js")!)
            //print("HTML : \(jsHandler)")
        } catch let error as NSError {
            print("Error: \(error)")
        }
        let ajaxHandler = WKUserScript(source: jsHandler, injectionTime: WKUserScriptInjectionTime.AtDocumentEnd, forMainFrameOnly: false)
        let userContentController = WKUserContentController()
        userContentController.addScriptMessageHandler(self, name: "callbackHandler")
        userContentController.addUserScript(ajaxHandler)
        wkWebConfig.userContentController = userContentController
        webView = WKWebView(frame: self.view.frame, configuration: wkWebConfig)
        webView.navigationDelegate = self
        
        self.view.addSubview(webView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: siteUrl)!))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = self.view.bounds
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print("script")
        print(message.body)
    }


    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //print("\(navigation.description)")
    }
    
    /*func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        print("\(navigationAction.request.URL)")
        
        if navigationAction.navigationType == .LinkActivated {
            print("navigation Cancel")
            decisionHandler(WKNavigationActionPolicy.Cancel)
        } else {
            
            /*decisionHandler(WKNavigationActionPolicy.Cancel)
            let controller = ViewController()
            controller.siteUrl = (navigationAction.request.URL?.absoluteString)!
            self.navigationController?.pushViewController(controller, animated: true)*/
        }
        
        print("navigation Allow")
        decisionHandler(WKNavigationActionPolicy.Allow)
    }*/
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        print("\(navigationResponse.response.URL)")
        print("responce Allow")
        decisionHandler(WKNavigationResponsePolicy.Allow)
    }
    
    
}

