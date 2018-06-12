//
//  Support.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 21/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get{
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = borderColor?.cgColor
        }
    }
}

import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension String {
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
}

func notifyUser(viewController: UIViewController, _ msg: String, err: String?) {
    let alert = UIAlertController(title: msg,message: err,preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    alert.addAction(cancelAction)
    viewController.present(alert, animated: true,completion: nil)
}

func showAlertController(viewController: UIViewController,_ message: String) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    viewController.present(alertController, animated: true, completion: nil)
}


