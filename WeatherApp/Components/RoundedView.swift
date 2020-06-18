//
//  RoundedView.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 17/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//

import Foundation
import UIKit

class RoundedView: UIView {
 
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }

}
