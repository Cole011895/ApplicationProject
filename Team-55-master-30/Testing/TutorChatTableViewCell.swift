//
//  ChatTableViewCell.swift
//  Testing
//
//  Created by Coleman Hedges on 3/26/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class TutorChatTableViewCell: UITableViewCell {
    @IBOutlet weak var TutorMessagehim: UILabel!
    @IBOutlet weak var Tutorphoto_one: UIImageView!
    @IBOutlet weak var photo_two: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var view_one_two: UIView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.view_one_two.layer.cornerRadius = 10.0
        /*
         self.view_two.layer.cornerRadius = 10.0
         */Tutorphoto_one.layer.borderWidth = 1.0
        Tutorphoto_one.layer.masksToBounds = false
        Tutorphoto_one.layer.borderColor = UIColor.white.cgColor
        Tutorphoto_one.layer.cornerRadius = Tutorphoto_one.frame.size.width/2
        Tutorphoto_one.clipsToBounds = true
        /*  photo_two.layer.borderWidth = 1.0
         photo_two.layer.masksToBounds = false
         photo_two.layer.borderColor = UIColor.white.cgColor
         photo_two.layer.cornerRadius = photo_two.frame.size.width/2
         photo_two.clipsToBounds = true*/
        // Configure the view for the selected state
    }
    
    
}
