//
//  ProjectTableViewCell.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 21/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var managerImageView: UIImageView!
    @IBOutlet weak var dev1ImageView: UIImageView!
    @IBOutlet weak var dev2ImageView: UIImageView!
    @IBOutlet weak var dev3ImageView: UIImageView!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var inProgressLabel: UILabel!
    @IBOutlet weak var inCompleteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
