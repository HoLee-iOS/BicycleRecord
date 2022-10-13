//
//  WeatherViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import CoreLocation
import RealmSwift

class WeatherViewController: BaseViewController {
    
    let main = WeatherView()
    
    lazy var locationManager: CLLocationManager = {
        let loc = CLLocationManager()
        loc.distanceFilter = 10000
        loc.desiredAccuracy = kCLLocationAccuracyBest
        loc.requestWhenInUseAuthorization()
        loc.delegate = self
        return loc
    }()
    
    let group = DispatchGroup()
    
    override func loadView() {
        self.view = main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        checkUserDeviceLocationServiceAuthorization()
        
        WeatherRepository.shared.fetch()
        setValue()
    }
    
    func setValue() {
        guard let task = WeatherRepository.shared.tasks.first else { return }
        main.weatherImage.image = UIImage(named: iconType(task.main))
        main.currentTemp.text = "\(task.temp)º"
        typeSwitch(task.main)
        miseSwitch(task.mise)
        choMiseSwitch(task.choMise)
        main.rainy.statusLabel.text = "\(Int(task.rain))%"
        main.windy.statusLabel.text = "\(task.windPower)m/s"
    }
}

extension WeatherViewController {
    //권한 요청
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        authorizationStatus = locationManager.authorizationStatus
        
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    //권한 체크
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            //앱을 사용하는 동안에 권한에 대한 위치 권한 요청
            locationManager.requestWhenInUseAuthorization()
        case .restricted ,.denied:
            print("DENIED")
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            //사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
            locationManager.startUpdatingLocation() //단점: 정확도를 위해서 무한대로 호출됨
        default: print("디폴트")
        }
    }
    
    //권한 거부시 경고창
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            
            //설정까지 이동하거나 설정 세부화면까지 이동하거나
            //한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 - 설정
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive) { _ in
            self.showRequestLocationServiceAlert()
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    //위치를 성공적으로 가지고 온 경우 실행
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //내위치 가져오기
        guard let lat = locationManager.location?.coordinate.latitude else { return }
        guard let lng = locationManager.location?.coordinate.longitude else { return }
        locationManager.stopUpdatingLocation()
        
        //내 위치 네비게이션 바에 표시
        locationManager.location?.fetchCityAndCountry { city, locality, error in
            guard let city = city, let locality = locality, error == nil else { return }
            self.navigationItem.title = "\(city), \(locality)"
            Weather.dong = locality
        }
        
        //앱이 처음 실행될때 날씨정보 값이 없거나
        //업데이트후 3시간이 지났거나
        //현 위치가 동 단위로 바뀔 경우 업데이트
        if WeatherRepository.shared.tasks.isEmpty || Date() > WeatherRepository.shared.tasks[0].time + 10800 || Weather.dong != UserDefaults.standard.string(forKey: "dong") {
            
            //현 위치를 동 단위로 저장
            UserDefaults.standard.set(Weather.dong, forKey: "dong")
            
            //기존 데이터가 있을 경우
            if !WeatherRepository.shared.tasks.isEmpty {
                guard let task = WeatherRepository.shared.tasks.first else { return }
                WeatherRepository.shared.deleteItem(item: task)
            }
            
            group.enter()
            //날씨 종류, 현재 기온, 풍속에 대한 정보 호출
            WeatherAPIManager.shared.callWeather(lat: lat, lon: lng) { main, temp, windPower in
                
                Weather.wea1 = (main, temp, windPower)
                
                //날씨 아이콘
                self.main.weatherImage.image = UIImage(named: self.iconType(main))
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
            WeatherAPIManager.shared.callDaily(lat: lat, lon: lng) { pop in
                
                Weather.wea2 = pop                
                
                //강수 확률
                //소수점 아예 지워줌
                self.main.rainy.statusLabel.text = "\(Int(pop))%"
                self.group.leave()
            }
            
            group.enter()
            //미세먼지, 초미세먼지에 대한 정보 호출
            WeatherAPIManager.shared.callAir(lat: lat, lon: lng) { mise, choMise in
                
                Weather.wea3 = (mise, choMise)
                
                //미세먼지 분기처리
                self.miseSwitch(mise)
                //초미세먼지 분기처리
                self.choMiseSwitch(choMise)
                
                self.group.leave()
            }
            
            group.notify(queue: .main) {
                guard let wea1 = Weather.wea1 else { return }
                guard let wea2 = Weather.wea2 else { return }
                guard let wea3 = Weather.wea3 else { return }
                
                let item = UserWeather(main: wea1.0, temp: wea1.1, windPower: wea1.2, rain: wea2, mise: wea3.0, choMise: wea3.1, time: Date())
                WeatherRepository.shared.saveRealm(item: item)
            }
        }
    }
    
    //위치 가져오지 못한 경우 실행(권한 거부시)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showRequestLocationServiceAlert()
    }
    
    //앱 실행시 제일 처음 실행
    //사용자의 위치 권한 상태가 바뀔때 알려줌
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
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
        case 0...30: self.main.mise.statusLabel.text = "좋음"
        case 31...50: self.main.mise.statusLabel.text = "보통"
        case 51...100: self.main.mise.statusLabel.text = "나쁨"
        case 101...500: self.main.mise.statusLabel.text = "매우 나쁨"
        default: self.main.mise.statusLabel.text = "매우 나쁨"
        }
    }
    
    func choMiseSwitch(_ choMise: Double) {
        switch choMise {
        case 0...15: self.main.choMise.statusLabel.text = "좋음"
        case 16...25: self.main.choMise.statusLabel.text = "보통"
        case 26...50: self.main.choMise.statusLabel.text = "나쁨"
        case 51...500: self.main.choMise.statusLabel.text = "매우 나쁨"
        default: self.main.choMise.statusLabel.text = "매우 나쁨"
        }
    }
    
    func typeSwitch(_ type: String) {
        switch type {
        case "Clear": self.main.todayLabel.text = "라이딩하기 너무 좋은 날이에요"
        case "Clouds": self.main.todayLabel.text = "라이딩하기 너무 좋은 날이에요"
        case "Atmosphere": self.main.todayLabel.text = "라이딩 하실 때 조심하셔야 하는 날이에요"
        case "Snow": self.main.todayLabel.text = "길이 많이 미끄러울 수 있으니 주의해야해요"
        case "Rain": self.main.todayLabel.text = "길이 많이 미끄러울 수 있으니 주의해야해요"
        case "Drizzle": self.main.todayLabel.text = "길이 많이 미끄러울 수 있으니 주의해야해요"
        case "Thunderstorm": self.main.todayLabel.text = "오늘 라이딩은 위험해요"
        default: self.main.todayLabel.text = "라이딩 하실 때 조심하셔야 하는 날이에요"
        }
    }
    
    func iconType(_ type: String) -> String {
        switch type {
        case "Clear": return "Clear"
        case "Clouds": return "Clouds"
        case "Mist": return "Atmosphere"
        case "Snow": return "Snow"
        case "Rain": return "Rain"
        case "Drizzle": return "Drizzle"
        case "Thunderstorm": return "Thunderstorm"
        default: return "Atmosphere"
        }
    }
}

