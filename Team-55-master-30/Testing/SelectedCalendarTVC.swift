//
//  SelectedCalendarTVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class SelectedCalendarTVC: UITableViewCell {
    
    var date: Date!
    var availID: Int!
    var isAppointment = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
