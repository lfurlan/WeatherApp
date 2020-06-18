//
//  RoundedButton.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 16/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    var selectedState: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.height / 2
    }

    override func layoutSubviews(){
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        backgroundColor = selectedState ? AppColor.Blue : AppColor.LigthGray
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        selectedState = !selectedState
//        self.layoutSubviews()
//    }
    
    func turnState(state: Bool){
        selectedState = state
        self.layoutSubviews()
    }

}
