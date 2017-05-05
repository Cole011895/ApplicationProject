//
//  ChatMeTableViewCell.swift
//  Testing
//
//  Created by Coleman Hedges on 3/26/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class TutorChatMeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var me_two: UIImageView!
    @IBOutlet weak var TutorMessageMe: UILabel!
    @IBOutlet weak var Tutorview_two: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.Tutorview_two.layer.cornerRadius = 10.0
        me_two.layer.borderWidth = 1.0
        me_two.layer.masksToBounds = false
        me_two.layer.borderColor = UIColor.white.cgColor
        me_two.layer.cornerRadius = me_two.frame.size.width/2
        me_two.clipsToBounds = true
        
        // Configure the view for the selected state
    }
    
}

