//
//  TaskAndBugDetailViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 28/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire
class TaskAndBugDetailViewController: UIViewController {

    var task: WorkItemFromTFS?
    var devImage: UIImage?
//    var comments: [Comment]?
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskPirority: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var devPicture: UIImageView!
    @IBOutlet weak var taskCardView: UIView!
    @IBOutlet weak var taskProfileView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        activityView.hidesWhenStopped = true
        activityView.center = self.tableView.center
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        view.addSubview(activityView)
        
        if let t = task {
            taskName.text = t.title
            taskPirority.text = {
                switch t.priority {
                case 1:
                    return "High"
                case 2:
                    return "Medium"
                case 3:
                    return "Low"
                case 4:
                    return "Very Low"
                default:
                    break
                }
                return ""
            }()
            status.text = t.state
            status.textColor = {
                switch t.state {
                case "Done":
                    return #colorLiteral(red: 0.2, green: 0.6784313725, blue: 0.3725490196, alpha: 1)
                case "Closed":
                    return #colorLiteral(red: 0.2, green: 0.6784313725, blue: 0.3725490196, alpha: 1)
                case "In Progress":
                    return #colorLiteral(red: 1, green: 0.8254478574, blue: 0.4373552203, alpha: 1)
                case "Active":
                    return #colorLiteral(red: 1, green: 0.8254478574, blue: 0.4373552203, alpha: 1)
                case "To Do":
                    return #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
                case "New":
                    return #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
                default:
                    return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }()
            descriptionLabel.text = t.description
            devPicture.image = devImage
            startDate.text = String((t.createdDate?.prefix(10))!)
  
            
//            let userID = UserDefaults.standard.integer(forKey: "UserID")
//            let accountName = UserDefaults.standard.string(forKey: "accountName")
//            let url = ("http://traxtfsapi.azurewebsites.net/trax/getworkitemcomments?witid=\(t.WorkItemID!)&userid=\(userID)&accountname=\(accountName!)")
//            let safeURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//            Alamofire.request(safeURL!).responseJSON { (response) in
//                do {
//                    let comments = try JSONDecoder().decode([Comment].self, from: response.data!)
//                    self.comments = comments
//                    print("pass")
//                    self.tableView.reloadData()
//                    self.activityView.stopAnimating()
//                } catch {
//                    print("error")
//                }
//            }
        }
        
        taskProfileView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50 + taskCardView.frame.height + 8)
        
        let role = UserDefaults.standard.string(forKey: "Role")
        if (role != "CEO" && task?.state != "Closed") {
            let button = UIBarButtonItem(image:  #imageLiteral(resourceName: "checked"), landscapeImagePhone: #imageLiteral(resourceName: "checked"), style: UIBarButtonItemStyle.done, target: self, action: #selector(doneTask))
            navigationItem.rightBarButtonItem = button
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func doneTask() {
        let alert = UIAlertController(title: "Confirmation", message: "Are you confirm to done this task or bug", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default) { (action) in
            print("Cancel")
        })
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.cancel) { (action) in
//            let userid = UserDefaults.standard.integer(forKey: "UserID")
//            let accountName = UserDefaults.standard.string(forKey: "accountName")
//            Alamofire.request("http://traxtfsapi.azurewebsites.net/trax/completeworkitem?userid=\(userid)&accountname=\(accountName!)&witid=\(self.task!.WorkItemID!)").resume()
//            self.navigationController?.popViewController(animated: true)
//            print("Done this task")
        })
        
        
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TaskAndBugDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task?.comment?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        let comment = task?.comment![indexPath.row]
        let token = UserDefaults.standard.string(forKey: "Token")
        getImage(imageUrl: (comment!.imageURL!), token: token!, result: { (image) in
            if (image != nil) {
                cell.pictureImageView.image = image
            } else {
                cell.pictureImageView.image = #imageLiteral(resourceName: "user")
            }
            
        })
        
        cell.commentFromLabel.text = comment?.commenterName ?? ""
        cell.commentLabel.text = comment?.description ?? ""
        cell.commentView.layer.cornerRadius = cell.commentLabel.bounds.height * 0.2
        return cell
//        return UITableViewCell()
    }
    
    
}
