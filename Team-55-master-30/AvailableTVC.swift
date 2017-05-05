//
//  TableViewCell.swift
//  Testing
//
//  Created by Coleman Hedges on 1/30/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class AvailableTVC: UITableViewCell {
   
    @IBOutlet var photo: UIImageView!
    @IBOutlet var clas_s: UILabel!
    @IBOutlet var rate: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet weak var rating: UIImageView!
    @IBOutlet weak var cosmosView: CosmosView!
    
    
    var tutorID: Int!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        photo.layer.borderWidth = 1.0
        photo.layer.masksToBounds = false
        photo.layer.borderColor = UIColor.white.cgColor
        photo.layer.cornerRadius = photo.frame.size.width/2
        photo.clipsToBounds = true
        // Configure the view for the selected state
    }

}
