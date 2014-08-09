//
//  SecondViewController.swift
//  Dictionary
//
//  Created by Shinji Tanaka on 7/26/14.
//  Copyright (c) 2014 Shinji Tanaka. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var tableView: UITableView?
    var navView: UINavigationBar?
    var history = HistoryManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navView = UINavigationBar(frame: CGRect(x: 0, y: 20, width: 320, height: 44))
        self.navView!.delegate = self
        let navItem = UINavigationItem(title: "History")
        self.navView?.pushNavigationItem(navItem, animated: false)
        let checkButton = UIBarButtonItem(title: "Check", style: .Bordered, target: self, action: Selector("showCheck"))
        navItem.rightBarButtonItem = checkButton
        self.view.addSubview(self.navView!)
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        self.tableView = UITableView(frame: CGRect(x: 0, y: 20 + 44, width: 320, height: screenHeight - 20 - 44))
        self.tableView!.dataSource = self
        self.tableView!.delegate = self

        self.view.addSubview(self.tableView!)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showCheck() {
        let modal = ModalViewController()
        self.presentViewController(modal, animated: false, completion: nil)
    }
}

func relativeDateStringForDate(date: NSDate) -> String {
    let units : NSCalendarUnit =
        NSCalendarUnit.CalendarUnitDay |
        NSCalendarUnit.CalendarUnitWeekOfYear |
        NSCalendarUnit.CalendarUnitMonth |
        NSCalendarUnit.CalendarUnitYear |
        NSCalendarUnit.CalendarUnitHour |
        NSCalendarUnit.CalendarUnitMinute |
        NSCalendarUnit.CalendarUnitSecond
    let now = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(units, fromDate: date, toDate: now, options: nil)
    
    if components.year > 0 {
        return "\(components.year) years ago"
    } else if components.month > 0 {
        return "\(components.month) months ago"
    } else if components.weekOfYear > 0 {
        return "\(components.weekOfYear) weeks ago"
    } else if components.day > 0 {
        if components.day > 1 {
            return "\(components.day) days ago"
        } else {
            return "Yesterday";
        }
    } else if components.hour > 0 {
        return "\(components.hour) hours ago"
    } else if components.minute > 0 {
        return "\(components.minute) minutes ago"
    } else if components.second > 0 {
        return "\(components.second) seconds ago"
    } else {
        return "Now";
    }
}

extension SecondViewController : UINavigationBarDelegate {

}

extension SecondViewController : UITableViewDelegate {
    func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        var text: String = self.history[indexPath.row].word
        var tabbar: UITabBarController = self.tabBarController
        tabbar.selectedViewController = tabbar.viewControllers[0] as UIViewController
        if let firstvc = tabbar.selectedViewController as? FirstViewController {
            firstvc.request(text)
        }
    }
}
    
extension SecondViewController : UITableViewDataSource {
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.history.size
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let row = indexPath.row
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.textLabel.text = "\(self.history[row].word) (\(self.history[row].count))"
        cell.detailTextLabel.text = relativeDateStringForDate(self.history[row].date)
        
        return cell
    }
}

