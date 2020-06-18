//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 13/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [Forecast]
    let city: City?
    
    enum CodingKeys: String, CodingKey {
        case cod, message, cnt, list, city
    }
}

struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let timezone, sunrise, sunset: Int?
    
    init(id: Int, name: String, coord: Coord? = nil, country: String? = nil,timezone: Int? = nil, sunrise: Int? = nil, sunset: Int? = nil) {
        self.id = id
        self.name = name
        self.coord = coord
        self.country = country
        self.timezone = timezone
        self.sunrise = sunrise
        self.sunset = sunset
    }

}

struct Coord: Codable {
    let lat, lon: Double?
}

struct Forecast: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]
    let clouds: Clouds?
    let wind: Wind?
    let rain: Rain?
    let sys: Sys?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt
        , main, weather, clouds, wind, rain, sys
        case dtTxt = "dt_txt"
    }
}

struct Clouds: Codable {
    let all: Int?
}

struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct Sys: Codable {
    let pod: Pod?
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

struct Weather: Codable {
    let id: Int?
    let main: MainEnum?
    let weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}


struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
