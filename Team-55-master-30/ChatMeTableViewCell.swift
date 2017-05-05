//
//  ChatMeTableViewCell.swift
//  Testing
//
//  Created by Coleman Hedges on 3/26/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class ChatMeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var me: UIImageView!
    @IBOutlet weak var MessageMe: UILabel!
    @IBOutlet weak var view_two: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.view_two.layer.cornerRadius = 10.0
        me.layer.borderWidth = 1.0
        me.layer.masksToBounds = false
        me.layer.borderColor = UIColor.white.cgColor
        me.layer.cornerRadius = me.frame.size.width/2
        me.clipsToBounds = true
        
        // Configure the view for the selected state
    }
    
}
