//
//  TaskAndBugDetailViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 28/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
class TaskAndBugDetailViewController: UIViewController {

    var task: WorkItem?
    var devImage: UIImage?
    var comments: [Comment]?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskPirority: UILabel!
    @IBOutlet weak var assignTo: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var devPicture: UIImageView!
    @IBOutlet weak var colorPirority: UIView!
    @IBOutlet weak var taskCardView: UIView!
    @IBOutlet weak var taskProfileView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if let t = task {
            taskName.text = t.WorkItemName
            if (t.Priority == 4 || t.Priority == 3) {
                colorPirority.backgroundColor = #colorLiteral(red: 0.1439316273, green: 0.6425683498, blue: 0.9966294169, alpha: 1)
            } else  if (t.Priority == 2) {
                colorPirority.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            } else  if (t.Priority == 1) {
                colorPirority.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            taskPirority.text = {
                switch t.Priority {
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
            status.text = t.Status
            status.textColor = {
                switch t.Status {
                case "Closed":
                    return #colorLiteral(red: 0.231372549, green: 0.7215686275, blue: 0.4470588235, alpha: 1)
                case "Active":
                    return #colorLiteral(red: 0.9992232919, green: 0.8253397346, blue: 0.4392935038, alpha: 1)
                case "New":
                    return #colorLiteral(red: 0.7058587074, green: 0.7064036727, blue: 0.7059431672, alpha: 1)
                default:
                    return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }()
            descriptionLabel.text = t.Description
            devPicture.image = devImage
//            assignTo.text = task!.assignTo
  
            
            let userID = UserDefaults.standard.integer(forKey: "UserID")
            let accountName = UserDefaults.standard.string(forKey: "accountName")
            let url = ("http://traxtfsapi.azurewebsites.net/trax/getworkitemcomments?witid=\(t.WorkItemID!)&userid=\(userID)&accountname=\(accountName!)")
            let safeURL = url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            Alamofire.request(safeURL!).responseJSON { (response) in
                do {
                    SVProgressHUD.show(withStatus: "Fetching...")
                    let comments = try JSONDecoder().decode([Comment].self, from: response.data!)
                    self.comments = comments
                    print("pass")
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                } catch {
                    print("error")
                }
            }
        }
        
        taskProfileView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50 + taskCardView.frame.height + 8)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TaskAndBugDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments![indexPath.row]
        cell.pictureImageView.image = {
            if let decodedData = Data(base64Encoded: comment.ImageUrl!, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: decodedData)
                return image
            } else {
                return UIImage()
            }
        }()
        cell.commentFromLabel.text = comment.Name ?? ""
        cell.commentLabel.text = comment.Text ?? ""
        cell.commentView.layer.cornerRadius = cell.commentLabel.bounds.height * 0.2
        return cell
//        return UITableViewCell()
    }
    
    
}
