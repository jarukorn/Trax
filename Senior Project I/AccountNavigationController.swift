//
//  AccountNavigationController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 15/5/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit

class AccountNavigationController: UINavigationController {

    var accountList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (accountList != nil) {
            let accountVc = self.storyboard?.instantiateViewController(withIdentifier: "accountList_vc") as! AccountListViewController
            accountVc.accountName = accountList
            pushViewController(accountVc, animated: true)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
