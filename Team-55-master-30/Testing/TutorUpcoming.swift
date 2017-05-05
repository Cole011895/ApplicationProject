//
//  TutorUpcoming.swift
//  Testing
//
//  Created by Coleman Hedges on 3/7/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class TutorUpcoming: UITableViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet var clas: UILabel!
    @IBOutlet var names: UILabel!
    @IBOutlet var photos: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        photos.layer.borderWidth = 1.0
        photos.layer.masksToBounds = false
        photos.layer.borderColor = UIColor.white.cgColor
        photos.layer.cornerRadius = photos.frame.size.width/2
        photos.clipsToBounds = true
        // Configure the view for the selected state
    }

}
