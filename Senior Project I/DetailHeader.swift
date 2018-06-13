//
//  DetailHeader.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 13/6/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit

class DetailHeader: UIView {
    
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskStatus: UILabel!
    @IBOutlet weak var taskDiscription: UILabel!
    @IBOutlet weak var taskPriority: UILabel!
    @IBOutlet weak var view: UIView!
    
    func set(task: WorkItemFromTFS) {
        
        taskName.text = task.title ?? ""
        taskDate.text = String((task.createdDate?.prefix(10))!) ?? ""
        taskStatus.text = task.state ?? ""
        taskDiscription.text = task.description ?? ""
//        view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: taskDiscription.frame.height + 8)
//        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: view.frame.height + 8)
        taskPriority.text = {
            switch task.priority {
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
        
        taskStatus.textColor = {
            switch task.state {
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
    }
    
}
