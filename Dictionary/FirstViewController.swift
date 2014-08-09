//
//  FirstViewController.swift
//  Dictionary
//
//  Created by Shinji Tanaka on 7/26/14.
//  Copyright (c) 2014 Shinji Tanaka. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {
    
    var webview: UIWebView = UIWebView()
    var textfield: UITextField!
    var history = HistoryManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textfield = UITextField(frame: CGRect(x: 0, y: 20, width: 320, height: 44))
        self.textfield.placeholder = "Input some word"
        //self.textfield.backgroundColor = UIColor.redColor()
        self.textfield.borderStyle = UITextBorderStyle.Line
        self.textfield.delegate = self
        self.textfield.autocapitalizationType = UITextAutocapitalizationType.None

        self.view.addSubview(textfield)
        
        //self.webview.frame = CGRectInset(self.view.bounds, 0, -50)
        self.webview.frame = CGRect(x: 0, y: 64, width: 320, height: self.view.bounds.size.height - 44 - 20)
        self.webview.delegate = self
        self.view.addSubview(self.webview)
        
        var wordsq = PFQuery(className: "Word")
        wordsq.orderByDescending("created_at")
        var words = wordsq.findObjects()
        //NSLog("%d objects", words.count)
        var testObject = PFObject(className:"TestObject")
        //testObject["foo"] = "bar"
        //testObject.saveInBackground()
        //NSLog("%s\n", testObject.save())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.request(textField.text)
        return true
    }
    
    // var newString = myString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    func normalize_word(raw_word: String) -> String {
        var word = ""
        var start = true
        var add_space = false
        var last_word: Character?
        for char in raw_word {
            if char != " " {
                if add_space == true {
                    word += " "
                    add_space = false
                }
                word += char
                start = false
            }
            if last_word != " " && char == " " && start == false {
                add_space = true
            }
            last_word = char
        }
        return word
    }
    
    func request(raw_word: String) {
        let word = self.normalize_word(raw_word)
        self.textfield.text = word
        
        history.create(word)
        let escapedWord = word.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url = NSURL.URLWithString("http://eow.alc.co.jp/search?q=" + escapedWord)
        var urlRequest = NSURLRequest(URL: url)
        self.webview.loadRequest(urlRequest)
        self.view.endEditing(true)
        //self.webview.becomeFirstResponder()
    }
    

    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

