//
//  StudentCalendarTVC.swift
//  Testing
//
//  Created by Coleman Hedges on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class StudentCalendarTVC: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var locations: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var subject: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
