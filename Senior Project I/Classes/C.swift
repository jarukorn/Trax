//
//  C.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 21/4/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import Foundation

struct Project: Decodable {
    var ProjectName: String?
    var TaskProgress: TaskProgress?
    var TeamMembers: TeamMembers?
}

struct TaskProgress : Decodable {
    var DueTask: Int?
    var DoingTask: Int?
    var DoneTask: Int?
    var WorkItemList: String?

}

struct TeamMembers : Decodable {
    var Count: String?
    var Value: [Member]?
}

struct Member : Decodable {
    var ID: String?
    var DisplayName: String?
    var ImageUrl: String?
    var UniqueName: String?
}

struct WorkItemList: Decodable {
    var Done: Int?
    var Doing: Int?
    var Due: Int?
    var TaskList: [WorkItem]?
    var BugList: [WorkItem]?
    var MemberList: [Developer]?
    
}

struct Developer: Decodable {
    var DisplayName: String?
    var WorkItemIDs: String?
    var Done: Int?
    var Doing: Int?
    var Due: Int?
}


struct WorkItem: Decodable {
    var WorkItemID: Int?
    var WorkItemType: String?
    var WorkItemName: String?
    var Description: String?
    var MemberName: String?
    var Status: String?
    var StartDateTime: String?
    var Priority: Int?
    var CommentCount: Int?
    
}

struct Comment: Decodable {
    var Text: String?
    var Name: String?
    var ImageUrl: String?
    var CreatedDateTime: String?
}

struct LoginAccessAndMyTask : Decodable {
    let isSuccess : Bool?
    let UserID : Int?
    let TFS_ID : String?
    let Email : String?
    let DisplayName : String?
    let ImageUrl : String?
    let Role : String?
    let TokenExpireDateTime : String?
    let AccountList : [String]?
    
}

struct MyDeveloperList: Decodable {
    var DisplayName: String?
    var ImageUrl: String?
    var TaskProgress: TaskProgress?
}

struct MyTask: Decodable {
    var Done: Int?
    var Doing: Int?
    var Due: Int?
    var TaskList: [WorkItemForMyTask]?
    var BugList: [WorkItemForMyTask]?
    var MemberList: [Developer]?
}

struct WorkItemForMyTask: Decodable {
    var WorkItemID: Int?
    var WorkItemType: String?
    var WorkItemName: String?
    var Description: String?
    var ProjectName: String?
    var MemberName: String?
    var ImageUrl: String?
    var ManHours: String?
    var Status: String?
    var StartDateTime: String?
    var Priority: Int?
    var CommentCount: Int?
    
}

