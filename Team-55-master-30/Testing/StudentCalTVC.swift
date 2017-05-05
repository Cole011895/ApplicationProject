//
//  StudentCalTVC.swift
//  Testing
//
//  Created by Coleman Hedges on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class StudentCalTVC: UITableViewCell {
    var date: String!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var open: UILabel!

    @IBOutlet weak var daily: UILabel!
    @IBOutlet weak var daynum: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
