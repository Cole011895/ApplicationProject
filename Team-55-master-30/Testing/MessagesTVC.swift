//
//  TableViewCell_two.swift
//  Testing
//
//  Created by Coleman Hedges on 2/4/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class MessagesTVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var tutorID: Int!
    var images: UIImage!
    
    @IBOutlet var messphoto: UIImageView!
    
    @IBOutlet var messname: UILabel!
    @IBOutlet var messmessage: UILabel!
    
    
   
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        messphoto.layer.borderWidth = 1.0
        messphoto.layer.masksToBounds = false
        messphoto.layer.borderColor = UIColor.white.cgColor
        messphoto.layer.cornerRadius = messphoto.frame.size.width/2
        messphoto.clipsToBounds = true
        // Configure the view for the selected state
    }

}
