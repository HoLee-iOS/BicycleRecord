//
//  WeatherViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import CoreLocation
import Kingfisher

class WeatherViewController: BaseViewController {
    
    let main = WeatherView()
    
    let location: CLLocationManager = {
        let loc = CLLocationManager()
        loc.distanceFilter = 1000
        return loc
    }()
    
    var wea1: (String, String, String, Double)?
    var wea2: Int?
    var wea3: (Double, Double)?
    
    let group = DispatchGroup()
    
    override func loadView() {
        self.view = main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        WeatherRepository.shared.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        location.startUpdatingLocation()
        guard let loc = location.location else { return }
        location.stopUpdatingLocation()
        

        //내 위치 네비게이션 바에 표시
        loc.fetchCityAndCountry { city, locality, error in
            guard let city = city, let locality = locality, error == nil else { return }
            self.navigationItem.title = "\(city), \(locality)"
        }

        //앱이 처음 실행될때 날씨정보 값이 없거나 3시간에 한번씩 날씨정보 업데이트
        if WeatherRepository.shared.tasks.isEmpty || Date() >= WeatherRepository.shared.tasks[0].time + 10800 {
            
            //기존 데이터가 있을 경우
            if !WeatherRepository.shared.tasks.isEmpty {
                guard let task = WeatherRepository.shared.tasks.first else { return }
                WeatherRepository.shared.deleteItem(item: task)
            }
            
            group.enter()
            //날씨 종류, 현재 기온, 풍속에 대한 정보 호출
            WeatherAPIManager.shared.callWeather(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude) { main, icon, temp, windPower in
                
                self.wea1 = (main, icon, temp, windPower)
                
                //날씨 아이콘
                self.main.weatherImage.kf.setImage(with: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png"))
                //날씨 종류
                self.typeSwitch(main)
                //현재 기온
                self.main.currentTemp.text = "\(temp)º"
                //풍속
                self.main.windy.statusLabel.text = "\(windPower)m/s"
                
                self.group.leave()
            }
            
            group.enter()
            //강수 확률에 대한 정보 호출
            WeatherAPIManager.shared.callDaily(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude) { pop in
                
                self.wea2 = pop
                
                //강수 확률
                self.main.rainy.statusLabel.text = "\(pop)%"
                self.group.leave()
            }
            
            group.enter()
            //미세먼지, 초미세먼지에 대한 정보 호출
            WeatherAPIManager.shared.callAir(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude) { mise, choMise in
                
                self.wea3 = (mise, choMise)
                
                //미세먼지 분기처리
                self.miseSwitch(mise)
                //초미세먼지 분기처리
                self.choMiseSwitch(choMise)
                
                self.group.leave()
            }
            
            group.notify(queue: .main) {
                
                guard let wea1 = self.wea1 else { return }
                guard let wea2 = self.wea2 else { return }
                guard let wea3 = self.wea3 else { return }

                let item = UserWeather(main: wea1.0, icon: wea1.1, temp: wea1.2, windPower: wea1.3, rain: wea2, mise: wea3.0, choMise: wea3.1, time: Date())
                WeatherRepository.shared.saveRealm(item: item)
            }
        }
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ locality:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.subLocality, $1) }
    }
}

extension WeatherViewController {
    func miseSwitch(_ mise: Double) {
        switch mise {
        case 0...50: self.main.mise.statusLabel.text = "좋음"
        case 51...100: self.main.mise.statusLabel.text = "보통"
        case 101...250: self.main.mise.statusLabel.text = "나쁨"
        case 251...500: self.main.mise.statusLabel.text = "매우 나쁨"
        default: print("값이 잘못되었습니다.")
        }
    }
    
    func choMiseSwitch(_ choMise: Double) {
        switch choMise {
        case 0...50: self.main.choMise.statusLabel.text = "좋음"
        case 51...100: self.main.choMise.statusLabel.text = "보통"
        case 101...250: self.main.choMise.statusLabel.text = "나쁨"
        case 251...500: self.main.choMise.statusLabel.text = "매우 나쁨"
        default: print("값이 잘못되었습니다.")
        }
    }
    
    func typeSwitch(_ type: String) {
        switch type {
        case "Clear": self.main.todayLabel.text = "라이딩하기 너무 좋은 날이에요"
        case "Clouds": self.main.todayLabel.text = "라이딩하기 너무 좋은 날이에요"
        case "Atmosphere": self.main.todayLabel.text = "라이딩 하실 때 잘 살피며 조심하셔야 하는 날이에요"
        case "Snow": self.main.todayLabel.text = "길이 많이 미끄러울 수 있으니 주의해야해요"
        case "Rain": self.main.todayLabel.text = "길이 많이 미끄러울 수 있으니 주의해야해요"
        case "Drizzle": self.main.todayLabel.text = "길이 많이 미끄러울 수 있으니 주의해야해요"
        case "Thunderstorm": self.main.todayLabel.text = "오늘 라이딩은 위험해요"
        default: print("에러")
        }
    }
}

