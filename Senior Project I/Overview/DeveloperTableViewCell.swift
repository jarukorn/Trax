//
//  DeveloperTableViewCell.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 21/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit

class DeveloperTableViewCell: UITableViewCell {

    @IBOutlet weak var developerName: UILabel!
    @IBOutlet weak var developerPic: UIImageView!
    @IBOutlet weak var doneProgressLabel: UILabel!
    @IBOutlet weak var doingProgessLabel: UILabel!
    @IBOutlet weak var remainningProgessLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
