//
//  API.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 30/5/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import Foundation
import Alamofire

let url = URL(string: "https://traxapplication.visualstudio.com/DefaultCollection/")
let apiVersion = "2.0"

func getProjectList(){
    let headers: HTTPHeaders = ["Authorization": "Basic Om90dGw1d2xlc2U1dmJwZWV1Y2oyNHJrZnVkYTN5Y3ljdWJ4Zmh6c25qejRzNGxoM3RieWE="]
    Alamofire.request("\(url!)_apis/projects?api-version=\(apiVersion)",headers: headers).responseJSON { (response) in
        print(response.result.value)
    }
}

//
//"\(url)_apis/projects?api-version=\(apiVersion)"
