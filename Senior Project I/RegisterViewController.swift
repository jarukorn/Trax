//
//  RegisterViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 17/4/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Alamofire
class RegisterViewController: UIViewController {

    
    @IBOutlet weak var credUsername: UITextField!
    @IBOutlet weak var credPassword: UITextField!
    @IBOutlet weak var accessToken: UITextField!
    @IBOutlet weak var rolesBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var expriedDate: UIButton!
    
    var pickerData: [String] =  ["CEO","Team Leader", "Developer"]
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.hideKeyboardWhenTappedAround()
    }
    
    var isAlreadySelected = false
    func picker(_ sender: UIButton) {
        let selectedIndex = { () -> Int in
            if (isAlreadySelected) {
                return UserDefaults.standard.integer(forKey: "selectedIndex")
            } else {
                isAlreadySelected = true
                return 0
            }
        }()
        ActionSheetStringPicker.show(withTitle: "Choose your roles", rows: pickerData , initialSelection: selectedIndex, doneBlock: {
            picker, value, index in
            self.rolesBtn.setTitle("\(index!)", for: .normal)
            UserDefaults.standard.set(value, forKey: "selectedIndex")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
    }
    
    @IBAction func rolesBtnClicked(_ sender: Any) {
        picker(rolesBtn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(_ sender: Any) {
        print("http://traxtfsapi.azurewebsites.net/tfs/register?cred_username=\(credUsername.text!)&cred_password=\(credPassword.text!)&role=\(rolesBtn.titleLabel!.text!)&token=\(accessToken.text!)&expire_in=\(expriedDate.titleLabel!.text!)")
        var role:String = ""
        if (rolesBtn.titleLabel?.text == "Team Leader") {
            role = "TeamLeader"
        } else {
            role = (rolesBtn.titleLabel?.text)!
        }
        Alamofire.request("http://traxtfsapi.azurewebsites.net/tfs/register?cred_username=\(credUsername.text!)&cred_password=\(credPassword.text!)&role=\(role)&token=\(accessToken.text!)&expire_in=\(expriedDate.titleLabel!.text!)").responseJSON { (response) in
            if response.result.value == nil {
                let alert = UIAlertController(title: "Connection Fail", message: "Server not response", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                if let result = response.result.value as? [String:AnyObject] {
                    if let response = result["IsSuccess"] as? Bool {
                        if response {
                            let alert = UIAlertController(title: "Successful", message: "You has been sign up to our app.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            DispatchQueue.main.async {
                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
                            let alert = UIAlertController(title: "Registration Fail", message: "Please check your Token.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            DispatchQueue.main.async {
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "There is a VSTS service problem", message: "Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            }
            
    }
    
    @IBAction func DatePickerClicked(_ sender: UIButton) {
        
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            if let temp = value as? Date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                self.expriedDate.setTitle(dateFormatter.string(from: temp), for: .normal)
            }
            
            
           
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        
        datePicker?.show()
    }
    
    @IBAction func openAccessTokenGuide(_ sender: Any) {
        UIApplication.shared.open((URL(string: "https://docs.microsoft.com/en-us/vsts/accounts/use-personal-access-tokens-to-authenticate?view=vsts")!), options: [:], completionHandler: nil)
    }
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
