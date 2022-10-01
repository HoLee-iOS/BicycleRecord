//
//  WeatherAPIManager.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import Foundation

import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherAPIManager {
    
    static let shared = WeatherAPIManager()
    
    private init() {}
    
    func callWeather(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping ((String, String, Double)->())) {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKey.weather)&lang=kr"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                
                let json = JSON(value)
                
                //날씨 종류
                let main = json["weather"][0]["main"].stringValue
                //현재 기온
                let temp = String(format: "%.1f", (json["main"]["temp"].doubleValue - 273.15))
                //풍속
                let windPower = json["wind"]["speed"].doubleValue
                
                completion(main, temp, windPower)
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func callDaily(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping ((Int)->())) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&cnt=1&appid=\(APIKey.daily)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                
                let json = JSON(value)
                
                //강수 확률
                let pop = json["list"]["pop"].intValue * 100
                
                completion(pop)
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callAir(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping ((Double, Double) -> ())) {
        let url = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&appid=\(APIKey.air)&lang=kr"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
                //성공케이스에 대한 설정
            case .success(let value):
                
                let json = JSON(value)
                
                //미세먼지
                let mise = json["list"][0]["components"]["pm10"].doubleValue
                //초미세먼지
                let choMise = json["list"][0]["components"]["pm2_5"].doubleValue
                
                completion(mise, choMise)
                
                //실패케이스에 대한 설정
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
