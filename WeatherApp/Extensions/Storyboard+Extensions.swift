//
//  Storyboard+Extensions.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 13/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//
import UIKit

extension UIStoryboard {
    static var main: UIStoryboard {
        return .init(name: "Main", bundle: .main)
    }
}

protocol StoryboardInitiable {
    static var storyboard: UIStoryboard { get }
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard() -> Self {
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}
