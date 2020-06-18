//
//  SessionHandler.swift
//  WeatherApp
//
//  Created by Lucas Furlan on 13/06/2020.
//  Copyright © 2020 Lucas Furlan. All rights reserved.
//


import Foundation

struct  ApiInfo {
    static let baseUrl: String = "http://api.openweathermap.org"
    static let forecast: String = "/data/2.5/forecast"
}

class SessionHandler{
    
    static var shared = SessionHandler()
    var requestHandler = RequestHandler()
    
    func fetchForecast(request: WeatherRequest, complete: @escaping (_ response: WeatherResponse? ) -> Void) -> Void {
        requestHandler.requestdata(url: "\(ApiInfo.baseUrl)\(ApiInfo.forecast)", type: WeatherResponse.self, requestData: request) { rta, error in
            DispatchQueue.main.async {
                complete(rta)
            }
        }
    }
    
}

class RequestHandler {
    
    public enum DashHTTPMethod: String {
        case get     = "GET"
        case post    = "POST"
    }
    
    
    func buildQueryString(fromDictionary parameters: [String:String]) -> String {
        var urlVars:[String] = []
        
        for (k, value) in parameters {
            if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                urlVars.append(k + "=" + encodedValue)
            }
        }
        return urlVars.isEmpty ? "" : urlVars.joined(separator: "&")
    }
    
    func requestdata<T:Decodable>(url :String, type: T.Type, method: DashHTTPMethod = .get, requestData: Encodable? = nil, completionHandler: @escaping (T?, Error?) -> ()) {
        var finalUrl = url
        if method == .get, let request = requestData {
            do {
                let params = try request.asDictionary()
                finalUrl = finalUrl + "?" + buildQueryString(fromDictionary: params)
            } catch {
                
            }
        }
        guard let urlR = URL(string: finalUrl) else {
            completionHandler(nil, nil)
            return
        }
        
        var request = URLRequest(url: urlR, timeoutInterval: Double.infinity)
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.dataTask(with: request){ data, response, err in
            guard let data = data else{
                completionHandler(nil, err)
                return
            }
            do{
                // let jsonTest = JSON(data)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                let json = try decoder.decode(type, from: data)
                completionHandler(json, nil)
            }catch {
                print(error)
                completionHandler(nil, error)
            }
            
        }
        task.resume()
    }
}


extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
}

