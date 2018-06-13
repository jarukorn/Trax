//
//  ProfileViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 21/4/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var devImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        nameLabel.text = UserDefaults.standard.string(forKey: "DisplayName")
        emailLabel.text = UserDefaults.standard.string(forKey: "UniqueName")
        roleLabel.text = UserDefaults.standard.string(forKey: "Role")
        devImage.image = {
            let picData = UserDefaults.standard.string(forKey: "ImageUrl")
            if let decodedData = Data(base64Encoded: picData!, options: .ignoreUnknownCharacters) {
                if let image = UIImage(data: decodedData) {
                    return image
                }
                return #imageLiteral(resourceName: "user")
            } else {
                return #imageLiteral(resourceName: "user")
            }
        }()
        
    }

    
    @IBAction func signOutClicked(_ sender: Any) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let login_vc = storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
        present(login_vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchCompany(_ sender: Any) {
        let accountVc = self.storyboard?.instantiateViewController(withIdentifier: "accountList_vc") as! AccountListViewController
        let account_nav = UINavigationController(rootViewController: accountVc)
        if let temp = UserDefaults.standard.array(forKey: "accountList") as? [String] {
            accountVc.accountName = temp
            self.present(account_nav, animated: true, completion: nil)
        }
        
        
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
