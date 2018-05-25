//
//  AccountListViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 15/5/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit

class AccountListViewController: UIViewController {

    var accountName: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Account Lists"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension AccountListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountName?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        cell.accountNameLabel.text = accountName?[indexPath.row] ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tabbar_vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar_vc") as! TabbarViewController
        UserDefaults.standard.set(accountName![indexPath.row], forKey: "accountName")
        self.present(tabbar_vc, animated: true, completion: nil)
    }
}
