//
//  LoginViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 15/4/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        signUpBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.hideKeyboardWhenTappedAround()
        activityView.center = view.center
        activityView.hidesWhenStopped = true
        if let username = UserDefaults.standard.string(forKey: "Username") {
            if let password = UserDefaults.standard.string(forKey: "Password") {
                fetch(username: username,password: password)
            }
        }
     
    }
    
    func fetch(username:String, password:String) {
        activityView.startAnimating()
        if Connectivity.isConnectedToInternet() {
            Alamofire.request("http://traxtfsapi.azurewebsites.net/tfs/login?username=\(username)&password=\(password)").responseJSON { (response) in
                if let json = response.result.value as? [String:AnyObject] {
                    let isSuccess = json["isSuccess"] as?  Bool
                    if let success = isSuccess {
                        if (success == true) {
                            do {
                                let loginAccessAndTask = try JSONDecoder().decode(LoginAccessAndMyTask.self, from: response.data!)
                                UserDefaults.standard.set(loginAccessAndTask.UserID, forKey: "UserID")
                                UserDefaults.standard.set(loginAccessAndTask.DisplayName, forKey: "DisplayName")
                                UserDefaults.standard.set(loginAccessAndTask.ImageUrl, forKey: "ImageUrl")
                                UserDefaults.standard.set(loginAccessAndTask.Email, forKey: "UniqueName")
                                UserDefaults.standard.set(loginAccessAndTask.Role, forKey: "Role")
                                self.activityView.stopAnimating()
                                if loginAccessAndTask.Role != nil {
                                    let accountVc = self.storyboard?.instantiateViewController(withIdentifier: "accountList_vc") as! AccountListViewController
                                    accountVc.accountName = loginAccessAndTask.AccountList
                                    let account_nav = UINavigationController(rootViewController: accountVc)
                                    
                                    self.present(account_nav, animated: true, completion: nil)
                                    
                                }
                                
                            } catch {
                                print("error")
                            }
                            
                            
                            
                        } else {
                            let alert = UIAlertController(title: "Authentication Fail", message: "Invaid username or passsword", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            DispatchQueue.main.async {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
                                self.present(vc, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Connection Fail", message: "There is no internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func loginBtnClicked(_ sender: Any) {
        fetch(username: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
        
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
