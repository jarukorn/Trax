//
//  TodayViewController.swift
//  tdExtensions
//
//  Created by Nattalie on 12/6/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var tdExtension: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tdExtension.text = "Check out your today tasks!"
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
