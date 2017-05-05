//
//  StudentSelectCalendarVC.swift
//  Testing
//
//  Created by Larson, Garrett Michael on 3/6/17.
//  Copyright © 2017 Coleman Hedges. All rights reserved.
//

import UIKit

class StudentSelectCalendarVC: UIViewController {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var tutorName: String!
    var tutorImage: UIImage!
    var subject: String!
    var time: String!
    var date: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.layer.borderWidth = 1.0
        img.layer.masksToBounds = false
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.cornerRadius = img.frame.size.width/2
        img.clipsToBounds = true
        
        img.image = tutorImage
        classLabel.text = subject
        nameLabel.text = tutorName
        timeLabel.text = time
        dateLabel.text = date
        
        // Do any additional setup after loading the view.
    }

}
