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
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    @IBOutlet weak var tableView: UITableView!
    let headerView = Bundle.main.loadNibNamed("DetailHeader", owner: self, options: nil)?.first as! DetailHeader
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.set(task: task!)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        activityView.hidesWhenStopped = true
        activityView.center = self.tableView.center
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        view.addSubview(activityView)
        
//        if let t = task {
//            taskName.text = t.title
//            taskPirority.text = {
//                switch t.priority {
//                case 1:
//                    return "High"
//                case 2:
//                    return "Medium"
//                case 3:
//                    return "Low"
//                case 4:
//                    return "Very Low"
//                default:
//                    break
//                }
//                return ""
//            }()
//            status.text = t.state
//            status.textColor = {
//                switch t.state {
//                case "Done":
//                    return #colorLiteral(red: 0.2, green: 0.6784313725, blue: 0.3725490196, alpha: 1)
//                case "Closed":
//                    return #colorLiteral(red: 0.2, green: 0.6784313725, blue: 0.3725490196, alpha: 1)
//                case "In Progress":
//                    return #colorLiteral(red: 1, green: 0.8254478574, blue: 0.4373552203, alpha: 1)
//                case "Active":
//                    return #colorLiteral(red: 1, green: 0.8254478574, blue: 0.4373552203, alpha: 1)
//                case "To Do":
//                    return #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
//                case "New":
//                    return #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
//                default:
//                    return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                }
//            }()
//            descriptionLabel.text = t.description
////            devPicture.image = devImage
//            startDate.text = String((t.createdDate?.prefix(10))!)
//
//        }
        
//        taskProfileView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50 + taskCardView.frame.height + 8)
        
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
            let accountName = UserDefaults.standard.string(forKey: "accountName")
            let token = UserDefaults.standard.string(forKey: "Token")
            completeWorkItem(accountName: accountName!, token: token!, witID: self.task!.ID!, result: { (isSuccess) in
                if (isSuccess) {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "Server Error", message: "Could not success this task.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                }
            })

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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView.frame.height + 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
    }
    
    
}
