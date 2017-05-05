//
//  ChatAvailableTVC.swift
//  Testing
//
//  Created by Coleman Hedges on 4/3/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class ChatAvailableTVC: UITableViewCell {
  
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    var tutorID: Int!
    var tutorPhoto: UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
