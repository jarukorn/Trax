//
//  BugTableViewCell.swift
//  Senior Project I
//
//  Created by Jarukorn Thuengjitvilas on 28/3/2561 BE.
//  Copyright © 2561 Jarukorn Thuengjitvilas. All rights reserved.
//

import UIKit

class BugTableViewCell: UITableViewCell {

    @IBOutlet weak var assignToPicture: UIImageView!
    @IBOutlet weak var bugNameLabel: UILabel!
    @IBOutlet weak var bugDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
