//
//  ViewController.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 18/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainPieChart: UIView!
    let chart = VBPieChart()

    override func viewDidLoad() {
        super.viewDidLoad()
        initMainGraph()
        
    }
    
    func initMainGraph() {
        mainPieChart.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.mainPieChart.addSubview(chart)
        chart.frame = CGRect(x: 50 , y: 0, width: view.frame.width-100, height: 300)
        chart.holeRadiusPrecent = 0
        chart.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        chart.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        chart.widthAnchor.constraint(equalToConstant: 200)
        chart.heightAnchor.constraint(equalToConstant: 150)
        
        let chartValues = [ ["name":"first", "value": 50, "color":UIColor(hexString:"dd191daa")],
                            ["name":"second", "value": 20, "color":UIColor(hexString:"d81b60aa")],
                            ["name":"third", "value": 40, "color":UIColor(hexString:"8e24aaaa")],
                            ["name":"fourth 2", "value": 70, "color":UIColor(hexString:"3f51b5aa")],
                            ["name":"fourth 3", "value": 65, "color":UIColor(hexString:"5677fcaa")],
                            ["name":"fourth 4", "value": 23, "color":UIColor(hexString:"2baf2baa")],
                            ["name":"fourth 5", "value": 34, "color":UIColor(hexString:"b0bec5aa")],
                            ["name":"fourth 6", "value": 54, "color":UIColor(hexString:"f57c00aa")]
        ]
        
        chart.setChartValues(chartValues as [AnyObject], animation:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    


}

