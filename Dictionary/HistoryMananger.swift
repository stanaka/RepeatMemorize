//
//  HistoryMananger.swift
//  Dictionary
//
//  Created by Shinji Tanaka on 7/26/14.
//  Copyright (c) 2014 Shinji Tanaka. All rights reserved.
//

import Foundation

struct History : Equatable {
    var word : String
    var count : Int
    var date : NSDate
}
func == (lhs: History, rhs: History) -> Bool {
    return lhs.word == rhs.word
}


class HistoryManager {
    
    class var sharedInstance: HistoryManager {
        struct Static {
            static let instance : HistoryManager = HistoryManager()
        }
        return Static.instance
    }
    
    var historyList: [History]
    
    var size : Int {
        return historyList.count
    }
    let STORE_KEY = "HistoryManager.store_key"
    
    subscript(index: Int) -> History {
        return historyList[index]
    }
    
    init(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let data = defaults.objectForKey(self.STORE_KEY) as? [String] {
            self.historyList = data.map { str in
                let array: [String] = str.componentsSeparatedByString(",")
                let word: String = array[0]
                var count: Int = 1
                if array.count > 1 {
                    count = array[1].toInt()!
                }
                var date: NSDate = NSDate()
                if array.count > 2 {
                    let date_str: String = array[2]
                    date = NSDate(timeIntervalSince1970: NSString(string:date_str).doubleValue)
                }
                return History(word: word, count: count, date: date)
            }
        } else {
            self.historyList = []
        }
    }
    
    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let data = self.historyList.map { history in
            "\(history.word),\(history.count),\(history.date.timeIntervalSince1970)"
        }
        defaults.setObject(data, forKey: self.STORE_KEY)
    }
    
    class func validateString(word: String!) -> Bool {
        return word != nil && word != ""
    }

    class func validate(history: History!) -> Bool {
        return history.word != nil && history.word != ""
    }
    
    func find(word: String) -> Int! {
        for (index, history) in enumerate(self.historyList) {
            if history.word == word {
                return index
            }
        }
        return nil
    }
    
    func create(word: String) -> Bool {
        if HistoryManager.validateString(word) {
            if let index = self.find(word) {
                var history = self.historyList[index]
                history.count++
                history.date = NSDate()
                self.remove(index)
                self.historyList.insert(history, atIndex: 0)
            } else {
                let history = History(word: word, count: 1, date: NSDate())
                self.historyList.insert(history, atIndex: 0)
            }
            self.save()
            
            var record = PFObject(className:"Word")
            record["word"] = word
            record["count"] = 1
            record["last_lookup"] = NSDate()
            record["stage"] = 1
            record.saveInBackground()

            return true
        }
        return false
    }
    
    func remove(index: Int) -> Bool {
        if(index > self.historyList.count) {
            return false
        }
        
        self.historyList.removeAtIndex(index)
        self.save()
        
        return true
    }
}