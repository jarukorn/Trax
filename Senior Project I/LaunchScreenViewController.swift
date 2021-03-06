//
//  LaunchScreenViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 24/5/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire
import LocalAuthentication
import UserNotifications

class LaunchScreenViewController: UIViewController {
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = self.view.center
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        activityView.startAnimating()
        self.view.addSubview(activityView)
        // Do any additional setup after loading the view.
        
    }
    
    func isTouchIdSupported() -> Bool {
        
        let context = LAContext()
        if #available(iOS 11.0, *){
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return context.biometryType == LABiometryType.touchID
            }
        }
        return false
    }
    
    func isFaceIdSupported() -> Bool {
        
        let context = LAContext()
        if #available(iOS 11.0, *){
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return context.biometryType == LABiometryType.faceID
            }
        }
        return false
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
                                UserDefaults.standard.set(loginAccessAndTask.TFS_ID, forKey: "TFS_ID")
                                UserDefaults.standard.set(loginAccessAndTask.Token, forKey: "Token")
                                UserDefaults.standard.set(loginAccessAndTask.TokenExpireDateTime, forKey: "Expire")
                                self.activityView.stopAnimating()
                                if loginAccessAndTask.Role != nil {
                                    let accountVc = self.storyboard?.instantiateViewController(withIdentifier: "accountList_vc") as! AccountListViewController
                                    accountVc.accountName = loginAccessAndTask.AccountList
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
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
                            DispatchQueue.main.async {
                                self.present(vc, animated: true, completion: nil)
                                self.present(alert, animated: true, completion: nil)
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
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        
        if let username = UserDefaults.standard.string(forKey: "Username") {
            if let password = UserDefaults.standard.string(forKey: "Password") {
                if (isTouchIdSupported()) {
                    print("TouchIDSupport")
                    let context = LAContext()
                    let reason = "Authenticate with Touch ID"
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason,
                                           reply: {(succes, error) in
                                            if succes {
                                                 self.fetch(username: username, password: password)
                                            }
                                            else {
                                                DispatchQueue.main.async(execute: {
                                                    let login_vc = self.storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
                                                    login_vc.modalTransitionStyle = .crossDissolve
                                                    self.present(login_vc, animated: true) {
                                                        print("pass")
                                                    }
                                                })
                                            }
                    })
                } else if (isFaceIdSupported()) {
                    print("FaceIDSupport")
                    let context = LAContext()
                    let reason = "Authenticate with Face ID"
                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason,
                                           reply: {(succes, error) in
                                            if succes {
                                                self.fetch(username: username, password: password)
                                            }
                                            else {
                                                DispatchQueue.main.async(execute: {
                                                    let login_vc = self.storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
                                                    login_vc.modalTransitionStyle = .crossDissolve
                                                    self.present(login_vc, animated: true) {
                                                        print("pass")
                                                    }
                                                })
                                            }
                                            
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        let login_vc = self.storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
                        login_vc.modalTransitionStyle = .crossDissolve
                        self.present(login_vc, animated: true) {
                            print("pass")
                        }
                    })
                }
            }
        } else {
            DispatchQueue.main.async(execute: {
                let login_vc = self.storyboard?.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
                login_vc.modalTransitionStyle = .crossDissolve
                self.present(login_vc, animated: true) {
                    print("pass")
                }
            })
        }
        
        
    }
    
}

