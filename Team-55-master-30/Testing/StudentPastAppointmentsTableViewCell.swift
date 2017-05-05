//
//  StudentPastAppointmentsTableViewCell.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 3/5/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class StudentPastAppointmentsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var classy: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var number: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
