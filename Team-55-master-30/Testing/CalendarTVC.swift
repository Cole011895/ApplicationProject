//
//  CalendarTVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class CalendarTVC: UITableViewCell {
    
    var finalDate: Date!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var daily: UILabel!
    @IBOutlet weak var daynum: UILabel!
    @IBOutlet weak var appt: UILabel!
    @IBOutlet weak var avail: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
