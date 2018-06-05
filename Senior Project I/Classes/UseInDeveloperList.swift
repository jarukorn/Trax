//
//  UseInDeveloperList.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 5/6/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import Foundation



// Seperate task by project


//struct Project {
//    var projectName: String?
//    var workitems = [WorkItemFromTFS]()
//}
//
//var projectNameList = [Project]()

//for task in (dev?.task)! {
//
//    if projectNameList.count == 0 {
//        var project = Project(projectName: task.projectName!, workitems: [WorkItemFromTFS]())
//        project.workitems.append(task)
//        projectNameList.append(project)
//    } else {
//        for i in 0...projectNameList.count-1 {
//            if (projectNameList[i].projectName == task.projectName) {
//                projectNameList[i].workitems.append(task)
//            } else {
//                var project = Project(projectName: task.projectName!, workitems: [WorkItemFromTFS]())
//                project.workitems.append(task)
//                projectNameList.append(project)
//            }
//        }
//    }
//}
//
//print(projectNameList.count)

//func numberOfSections(in tableView: UITableView) -> Int {
//    return projectNameList.count
//}
//
//func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    return projectNameList[section].projectName
//}
