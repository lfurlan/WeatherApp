//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 16/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//

import Foundation
import UIKit

struct ForecastData{
    let day: Int?
    let dayName: String?
    let hour: Int?
    let icon: String?
    let weatherDescription: String?
    let temp: Double?
    
}


class WeatherViewModel: NSObject{
    var weatherRequest: WeatherRequest?
    var weatherResponse: WeatherResponse?
    var cities: [City] = []
    var currentCityId: String?
    var forecasts: [ForecastData] = []
    var groupedForecastsSorted: [Dictionary<Int, [WeatherApp.ForecastData]>.Element] = []
 
    
    override init() {
        super.init()
        initMockData()
    }
    
    func initMockData(){
        //ciudad a seleccionar
        cities.append(City(id: 3433955, name: "Ciudad Autónoma de Buenos Aires"))
        cities.append(City(id: 3836277, name: "Santa Fe"))
        cities.append(City(id: 3430863, name: "Mar del Plata"))
        cities.append(City(id: 3841956, name: "Paraná"))
        cities.append(City(id: 3844421, name: "Mendoza"))
        
        //request
        weatherRequest = WeatherRequest(id: "", APPID: "4bf0a75b9945ed848ddfc4da0c3e1d49")
    }
    
    func fetchForecast(complete: @escaping (_ response: Bool? ) -> Void) -> Void {
        if let request = weatherRequest {
            SessionHandler.shared.fetchForecast(request: request){response in
                self.weatherResponse = response
                self.procressResponse()
                complete(true)
            }
        }
    }
    
    func procressResponse() {
        if let response = weatherResponse {
            //dayOfWeek()
            for forecast in response.list{
                if let dateText = forecast.dtTxt{
                    let date = dateText.toDate()
                    let day = date?.get(.day) ?? 0
                    let dayName = date?.dayOfWeek()
                    let hour = date?.get(.hour) ?? -1

                    let icon = forecast.weather[0].icon
                    let weatherDescription = forecast.weather[0].weatherDescription
                    let temp = forecast.main?.temp
                    
                    forecasts.append(ForecastData(day: day, dayName: dayName, hour: hour, icon: icon, weatherDescription: weatherDescription, temp: temp))
                    
                }
            }
            self.groupedForecastsSorted  = Dictionary(grouping: forecasts, by: {($0.day ?? 0)}).sorted(by: { $0.0 < $1.0 })
        }
    }
    
    func sortWithKeys(_ dict: [String: Any]) -> [String: Any] {
        let sorted = dict.sorted(by: { $0.key < $1.key })
        var newDict: [String: Any] = [:]
        for sortedDict in sorted {
            newDict[sortedDict.key] = sortedDict.value
        }
        return newDict
    }
}
