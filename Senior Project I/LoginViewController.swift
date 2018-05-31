//
//  LoginViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 15/4/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire

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
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        view.addSubview(activityView)
        if let username = UserDefaults.standard.string(forKey: "Username") {
            if let password = UserDefaults.standard.string(forKey: "Password") {
                fetch(username: username,password: password)
            }
        }
     
    }
    
    func fetch(username:String, password:String) {
        if (username == "" || password == "") {
            let alert = UIAlertController(title: "Login Fail", message: "Please enter username and password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        activityView.startAnimating()
        if !Connectivity.isConnectedToInternet() {
            let alert = UIAlertController(title: "Connection Fail", message: "There is no internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        print("http://traxtfsapi.azurewebsites.net/tfs/login?username=\(username)&password=\(password)")
        Alamofire.request("http://traxtfsapi.azurewebsites.net/tfs/login?username=\(username)&password=\(password)").responseJSON { (response) in
                if let json = response.result.value as? [String:AnyObject] {
                    let isSuccess = json["isSuccess"] as?  Bool
                    if let success = isSuccess
                    {
                        if (success == true)
                        {
                            do {
                                let loginAccessAndTask = try JSONDecoder().decode(LoginAccessAndMyTask.self, from: response.data!)
                                UserDefaults.standard.set(loginAccessAndTask.UserID, forKey: "UserID")
                                UserDefaults.standard.set(loginAccessAndTask.DisplayName, forKey: "DisplayName")
                                UserDefaults.standard.set(loginAccessAndTask.ImageUrl, forKey: "ImageUrl")
                                UserDefaults.standard.set(loginAccessAndTask.Email, forKey: "UniqueName")
                                UserDefaults.standard.set(loginAccessAndTask.Role, forKey: "Role")
                                UserDefaults.standard.set(loginAccessAndTask.TFS_ID, forKey: "TFS_ID")
                                UserDefaults.standard.set(loginAccessAndTask.TokenExpireDateTime, forKey: "Expire")
                                UserDefaults.standard.set(username, forKey: "Username")
                                UserDefaults.standard.set(password, forKey: "Password")
                                self.activityView.stopAnimating()
                                if loginAccessAndTask.Role != nil {
                                    let accountVc = self.storyboard?.instantiateViewController(withIdentifier: "accountList_vc") as! AccountListViewController
                                    accountVc.accountName = loginAccessAndTask.AccountList
                                    UserDefaults.standard.set(loginAccessAndTask.AccountList, forKey: "accountName")
                                    
                                    UserDefaults.standard.set(loginAccessAndTask.AccountList, forKey: "accountList")
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
                                self.present(alert, animated: true, completion: nil)
                            }
                            self.activityView.stopAnimating()
                        }
                    }
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
