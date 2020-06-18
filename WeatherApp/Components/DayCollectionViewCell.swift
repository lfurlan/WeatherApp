//
//  DayCollectionViewCell.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 17/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: RoundedView!
    @IBOutlet weak var dayNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
