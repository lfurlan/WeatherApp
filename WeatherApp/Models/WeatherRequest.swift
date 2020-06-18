//
//  WeatherRequest.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 13/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//

import Foundation

struct WeatherRequest: Encodable {
    var id: String
    var APPID: String
    var units: String
    var lang: String
    
    init(id: String, APPID: String, units: String = "metric", lang: String = "sp") {
        self.id = id
        self.APPID = APPID
        self.units = units
        self.lang = lang
    }
}

extension Encodable {
    func toJSONData() -> Data? { try? JSONEncoder().encode(self) }
}
