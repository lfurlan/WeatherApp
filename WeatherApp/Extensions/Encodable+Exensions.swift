//
//  Encodable+Exensions.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 16/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: String] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] else {
            throw NSError()
        }
        return dictionary
    }
}
