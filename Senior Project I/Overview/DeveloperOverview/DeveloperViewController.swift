//
//  DeveloperViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 28/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire
class DeveloperViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var devImageView: UIImageView!
    @IBOutlet weak var devNameLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var doneLabel: UILabel!
    @IBOutlet weak var doingLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    var dev : MemberTaskInformation?
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Developer Overview"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        activityView.hidesWhenStopped = true
        activityView.center = self.tableViewList.center
        activityView.color = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        activityView.startAnimating()
        
        devNameLabel.text = dev?.teamMember?.name
        devImageView.image = dev?.teamMember?.image
        doneLabel.text = "\(dev!.taskProgress.complete)"
        doingLabel.text = "\(dev!.taskProgress.doing)"
        leftLabel.text = "\(dev!.taskProgress.new)"
        
        let accountName = UserDefaults.standard.string(forKey: "accountName")
        let token = UserDefaults.standard.string(forKey: "Token")
        
        if dev?.task?.count != 0 {
            self.dev?.task?.sort(by: { (firstItem, secondItem) -> Bool in
                firstItem.stateValue < secondItem.stateValue
            })
            for i in 0...(dev?.task?.count)!-1 {
                var interation = 0
                getComment(accountName: accountName!, token: token!, task: (dev?.task![i])!) { (CommentList) in
                    self.dev?.task![i].comment = CommentList
                    interation = interation + 1
                    if (interation == self.dev!.task!.count-1) {
                        self.tableViewList.reloadData()
                    }
                }
            }
        }
        
        if dev?.bug?.count != 0 {
            self.dev?.bug?.sort(by: { (firstItem, secondItem) -> Bool in
                firstItem.stateValue < secondItem.stateValue
            })
            for i in 0...(dev?.bug?.count)!-1 {
                var interation = 0
                getComment(accountName: accountName!, token: token!, task: (dev?.bug![i])!) { (CommentList) in
                    self.dev?.bug![i].comment = CommentList
                    interation = interation + 1
                    if (interation == self.dev!.bug!.count-1) {
                        self.tableViewList.reloadData()
                    }
                }
            }
        }
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return dev?.task!.count ?? 0
        case 1:
            return dev?.bug!.count ?? 0
        default:
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell") as! TaskTableViewCell
        switch segmentControl.selectedSegmentIndex {
        case 0,1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell", for: indexPath) as! TaskTableViewCell
            cell.selectionStyle = .none
            var taskandBugInstance = WorkItemFromTFS()
            switch segmentControl.selectedSegmentIndex {
            case 0:
                taskandBugInstance = (dev!.task![indexPath.row])
            case 1:
                taskandBugInstance = (dev!.bug![indexPath.row])
            default:
                break
            }
            cell.taskTitle.text = taskandBugInstance.title
            var temp = ""
            switch taskandBugInstance.priority {
            case 1:
                temp = "High"
            case 2:
                temp = "Medium"
            case 3:
                temp = "Low"
            case 4:
                temp = "Very Low"
            default:
                break
            }
            cell.pirorityLabel.text = temp
            switch taskandBugInstance.state {
            case "Done":
                cell.statusColorView.backgroundColor = #colorLiteral(red: 0.2316122055, green: 0.7209670544, blue: 0.4477117658, alpha: 1)
            case "Closed":
                cell.statusColorView.backgroundColor = #colorLiteral(red: 0.2316122055, green: 0.7209670544, blue: 0.4477117658, alpha: 1)
            case "In Progress":
                cell.statusColorView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            case "Active":
                cell.statusColorView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            case "To Do":
                cell.statusColorView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            case "New":
                cell.statusColorView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            case .none:
                break
            case .some(_):
                break
            }
            
            if let description = taskandBugInstance.description {
                cell.descriptionLabel.text = "\(description)"
            }
            
            cell.numberCommentLabel.text = "\(taskandBugInstance.comment?.count ?? 0)"
            var startDate = ""
            if let date = taskandBugInstance.createdDate {
                startDate = String(date.prefix(10))
                startDate = startDate.replacingOccurrences(of: "-", with: "/")
                let temp = startDate.split(separator: "/")
                startDate = "\(temp[2])/\(temp[1])/\(temp[0])"
            }
            cell.dateLabel.text = startDate
            return cell
        default:
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = dev?.task![indexPath.row]
            vc.navigationItem.title = "Task Detail"
            vc.devImage = nil
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = storyboard?.instantiateViewController(withIdentifier: "taskandbugdetail") as! TaskAndBugDetailViewController
            vc.task = dev?.bug![indexPath.row]
            vc.navigationItem.title = "Bug Detail"
            vc.devImage = nil
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func changedSegment(_ sender: Any) {
        tableViewList.reloadData()
    }
    

}
