//
//  SelectCompanyViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 19/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit
import Alamofire


struct Company {
    var companyName: String?
    var companyPicture: String?
}

class SelectCompanyViewController: UIViewController  {

    let company = [Company(companyName: "Genxas", companyPicture: "Genxas"),
                   Company(companyName: "Microsoft", companyPicture: "Microsoft"),
                   Company(companyName: "Apple", companyPicture: "Apple")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Company"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension SelectCompanyViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return company.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "companycell", for: indexPath) as! CompanyCollectionViewCell
        cell.companyName.text = company[indexPath.row].companyName
        cell.companyPicture.image = UIImage(named: company[indexPath.row].companyPicture! )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "selectproject_vc") as! SelectProjectViewController
        vc.accountName = company[indexPath.row].companyName
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

