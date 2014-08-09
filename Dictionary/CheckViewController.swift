//
//  CheckViewController.swift
//  Dictionary
//
//  Created by Shinji Tanaka on 8/3/14.
//  Copyright (c) 2014 Shinji Tanaka. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
    var label: UILabel?
    var webview: UIWebView = UIWebView()
    var okButton: UIButton?
    var showButton: UIButton?
    var navView: UINavigationBar?
    var words: [String]?
    
    override func viewDidLoad() {
        
        self.navView = UINavigationBar(frame: CGRect(x: 0, y: 20, width: 320, height: 44))
        self.navView!.delegate = self
        let navItem = UINavigationItem(title: "1 / 10")
        self.navView?.pushNavigationItem(navItem, animated: false)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Bordered, target: self, action: Selector("cancel"))
        navItem.leftBarButtonItem = cancelButton
        self.view.addSubview(self.navView!)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.label = UILabel(frame: CGRect(x: 0, y: 70, width: 320, height: 44))
        self.label!.text = "Word"
        self.label!.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.label!)

        self.webview.frame = CGRect(x: 0, y: 110, width: 320, height: self.view.bounds.size.height - 110 - 60 - 5)
        self.webview.delegate = self
        self.view.addSubview(self.webview)
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        self.okButton = UIButton(frame: CGRect(x: 50, y: screenHeight - 60, width: 100, height: 44))
        self.okButton!.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.okButton!.setTitle("Next", forState: .Normal)
        self.okButton!.layer.cornerRadius = 10
        self.okButton!.layer.borderWidth = 1
        self.okButton!.addTarget(self, action: Selector("next"), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.okButton!)

        self.showButton = UIButton(frame: CGRect(x: 200, y: screenHeight - 60, width: 100, height: 44))
        self.showButton!.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.showButton!.setTitle("Unknown", forState: .Normal)
        self.showButton!.addTarget(self, action: Selector("showAnswer"), forControlEvents: UIControlEvents.TouchUpInside)
        self.showButton!.layer.cornerRadius = 10
        self.showButton!.layer.borderWidth = 1
        self.view.addSubview(self.showButton!)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.words = ["aaa", "bbb"]
        self.next()
    }

    func cancel() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    func showAnswer() {
        let word = self.label!.text
        
        let escapedWord = word.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = NSURL.URLWithString("http://eow.alc.co.jp/search?q=" + escapedWord)
        var urlRequest = NSURLRequest(URL: url)
        self.webview.loadRequest(urlRequest)
    }

    func next() {
        if self.words!.count > 0 {
            self.label!.text = self.words![0]
            self.words!.removeAtIndex(0)
            let url = NSURL.URLWithString("about:blank")
            self.webview.loadRequest(NSURLRequest(URL:url))
        } else {
            self.label!.text = "Finished"
        }
    }
}

extension ModalViewController: UINavigationBarDelegate {
}

extension ModalViewController: UIWebViewDelegate {
    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}