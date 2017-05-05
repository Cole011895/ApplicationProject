//
//  TableViewCell_four.swift
//  Testing
//
//  Created by Coleman Hedges on 2/17/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class UpcomingTVC: UITableViewCell {

    @IBOutlet var photos: UIImageView!
    @IBOutlet var clas: UILabel!
    @IBOutlet var names: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var tutorName: String!
    var tutorImage: UIImage!
    var subject: String!
    var time: String!
    var date: String!
    
    
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
