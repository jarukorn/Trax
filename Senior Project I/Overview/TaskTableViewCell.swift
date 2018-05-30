//
//  TaskTableViewCell.swift
//  Alamofire
//
//  Created by Jarukorn Thuengjitvilas on 21/3/2561 BE.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var pirorityLabel: UILabel!
    @IBOutlet weak var numberCommentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var colorPirority: UIView!
    @IBOutlet weak var statusColorView: UIView!
    @IBOutlet weak var devPic: UIImageView!
    @IBOutlet weak var projectName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
