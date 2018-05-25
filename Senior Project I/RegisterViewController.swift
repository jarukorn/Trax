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
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var accessToken: UITextField!
    @IBOutlet weak var rolesBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    
    var pickerData: [String] =  ["CEO","Team Leader", "Developer"]
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.hideKeyboardWhenTappedAround()
    }
    
    func picker(_ sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: "Choose your roles", rows: pickerData , initialSelection: 1, doneBlock: {
            picker, value, index in
            self.rolesBtn.setTitle("\(index!)", for: .normal)
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
       print("http://traxtfsapi.azurewebsites.net/tfs/register?cred_username=\(credUsername.text!)&cred_password=\(credPassword.text!)@&email=\(email.text!)&role=\(rolesBtn.titleLabel!.text!)")
        var role:String = ""
        if (rolesBtn.titleLabel?.text == "Team Leader") {
            role = "TeamLeader"
        } else {
            role = (rolesBtn.titleLabel?.text)!
        }
        Alamofire.request("http://traxtfsapi.azurewebsites.net/tfs/register?cred_username=\(credUsername.text!)&cred_password=\(credPassword.text!)@&email=\(email.text!)&role=\(role)").responseJSON { (response) in
            if let result = response.result.value as? [String:AnyObject] {
                if let response:String = result["Response"] as? String {
                    let alert = UIAlertController(title: response, message: "You has been sign up to our app.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Some Error Occur", message: "Something went wrong.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                
            }
        }
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
