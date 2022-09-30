//
//  MapViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import CoreLocation
import NMapsMap
import SnapKit
import DropDown
import RealmSwift

class ViewController: BaseViewController {
    
    let main = MainView()
    
    let popup = PopUpView()
    
    var locationManager: CLLocationManager = {
        let loc = CLLocationManager()
        loc.distanceFilter = 10000
        return loc
    }()
    
    lazy var mapView = main.mapview
    
    let group = DispatchGroup()
    
    var mark: NMFMarker?
    
    override func loadView() {
        self.view = main
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNetwork), name: Notification.Name("network"), object: nil)
        
        //앱 초기설정 및 Realm 업데이트 시 실행
        if MapRepository.shared.tasks.isEmpty || MapRepository.shared.tasks.count > UserDefaults.standard.integer(forKey: "cnt") {
            showToastMessage("편의시설 정보를 조회중입니다.")
            group.enter()
            BicycleAPIManager.shared.callRequest(startIndex: 1, endIndex: 1000) { loc, count  in
                UserDefaults.standard.set(count, forKey: "cnt")
                loc.forEach {
                    if $0.2.contains("공기") || $0.2.contains("주입기") {
                        let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 0)
                        MapRepository.shared.saveRealm(item: task)
                    } else if $0.2.contains("주차") || $0.2.contains("거치") || $0.2.contains("보관") {
                        let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 1)
                        MapRepository.shared.saveRealm(item: task)
                    } else {
                        let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 2)
                        MapRepository.shared.saveRealm(item: task)
                    }
                }
                self.group.leave()
            }
            
            group.enter()
            BicycleAPIManager.shared.callRequest(startIndex: 1001, endIndex: 2000) { loc, count in
                loc.forEach {
                    if $0.2.contains("공기") || $0.2.contains("주입기") {
                        let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 0)
                        MapRepository.shared.saveRealm(item: task)
                    } else if $0.2.contains("주차") || $0.2.contains("거치") || $0.2.contains("보관") {
                        let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 1)
                        MapRepository.shared.saveRealm(item: task)
                    } else {
                        let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 2)
                        MapRepository.shared.saveRealm(item: task)
                    }
                }
                self.group.leave()
            }
            
            group.notify(queue: .main) {
                BicycleAPIManager.shared.callRequest(startIndex: 2001, endIndex: UserDefaults.standard.integer(forKey: "cnt")) { loc, count in
                    loc.forEach {
                        if $0.2.contains("공기") || $0.2.contains("주입기") {
                            let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 0)
                            MapRepository.shared.saveRealm(item: task)
                        } else if $0.2.contains("주차") || $0.2.contains("거치") || $0.2.contains("보관") {
                            let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 1)
                            MapRepository.shared.saveRealm(item: task)
                        } else {
                            let task = UserMap(lat: $0.0, lng: $0.1, title: $0.2, info: $0.3, id: $0.4, address: $0.5, type: 2)
                            MapRepository.shared.saveRealm(item: task)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapRepository.shared.fetch()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        mapView.touchDelegate = self
        mapView.addCameraDelegate(delegate: self)
        
        view.backgroundColor = .white
        
        setActions()
        
        checkUserDeviceLocationServiceAuthorization()
        
        mapView.setLayerGroup(NMF_LAYER_GROUP_BICYCLE, isEnabled: true)
        mapView.isIndoorMapEnabled = true
        
        markerCluster()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favoriteDataSend), name: Notification.Name("data"), object: nil)
    }
    
    override func configure() {
        self.navigationItem.title = "자전거 편의시설"
        
        //바버튼 설정
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonClicked))
        self.navigationItem.rightBarButtonItems = [searchButton]
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        //백버튼 설정
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func setActions() {
        main.downButton.addTarget(self, action: #selector(downButtonClicked), for: .touchUpInside)
        main.locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        popup.popupSearchButton.addTarget(self, action: #selector(popupSearchButtonClicked), for: .touchUpInside)
        popup.popupFavoriteButton.addTarget(self, action: #selector(popupFavoriteButtonClicked), for: .touchUpInside)
    }
    
    func markerDelete() {
        Marker.markers.forEach {
            $0.mapView = nil
        }
    }
    
    func markerAdd(_ type: Int) {
        if type == 3 {
            Marker.markers.forEach {
                $0.mapView = mapView
            }
        }
        Marker.markers.filter { $0.userInfo["type"] as! Int == type }.forEach {
            $0.mapView = mapView
        }
    }
    
    func markerCluster() {
        Marker.markers.forEach {
            if $0.userInfo["type"] as! Int == 0 {
                $0.zIndex = -10
            } else if $0.userInfo["type"] as! Int == 1 {
                $0.zIndex = 0
            } else {
                $0.zIndex = 10
            }
            $0.isHideCollidedMarkers = true
        }
    }
    
    func show(completion: @escaping () -> Void = {}) {
        self.popup.snp.makeConstraints {
            $0.leading.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(self.view.safeAreaLayoutGuide).multipliedBy(0.21)
        }
        self.main.locationButton.snp.remakeConstraints {
            $0.bottom.equalTo(popup.snp.top).offset(-20)
            $0.trailing.equalTo(-20)
            $0.height.width.equalTo(44)
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: { self.view.layoutIfNeeded() },
            completion: { _ in completion() }
        )
    }
    
    @objc func updateNetwork(_ notification: Notification) {
        mapView.authorize()
    }
    
    @objc func downButtonClicked() {
        main.dropDown.show()
    }
    
    @objc func locationButtonClicked() {
        //현위치 불러오기
        locationManager.startUpdatingLocation()
        guard let lat = locationManager.location?.coordinate.latitude else { return }
        guard let lng = locationManager.location?.coordinate.longitude else { return }
        locationManager.stopUpdatingLocation()
        //현위치를 표시해줄 오버레이 객체 생성
        let locationOverlay = mapView.locationOverlay
        //오버레이 객체 보이게하기
        locationOverlay.hidden = false
        //현위치에 오버레이 표시
        locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
        //현위치로 카메라 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: locationOverlay.location, zoomTo: 15)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
        markerCluster()
    }
    
    @objc func popupSearchButtonClicked() {
        let text = popup.popupText.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "nmap://route/walk?dlat=\(popup.lat!)&dlng=\(popup.lng!)&dname=\(text!)&appname=com.skylerLee.Example1")!
        let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    @objc func popupFavoriteButtonClicked() {
        let arr = MapRepository.shared.tasks.where { $0.id == popup.id! }
        MapRepository.shared.updateFavorite(item: arr[0])
        
        arr[0].favorite ? popup.popupFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : popup.popupFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @objc func searchButtonClicked() {
        let vc = SearchViewController()
        vc.selectRow = { i in
            
            guard let i = i else { return }
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: i.lat, lng: i.lng), zoomTo: 15)
            cameraUpdate.animation = .easeIn
            self.mapView.moveCamera(cameraUpdate)
            
            self.view.addSubview(self.popup)
            self.popup.isHidden = false
            
            i.favorite ? self.popup.popupFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : self.popup.popupFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            
            if i.type == 0 {
                self.popup.layer.borderColor = Colors.green.cgColor
                self.popup.popupLine.backgroundColor = Colors.green
                self.popup.popupFavoriteButton.tintColor = Colors.green
                self.popup.popupIcon.tintColor = Colors.green
            } else if i.type == 1 {
                self.popup.layer.borderColor = Colors.orange.cgColor
                self.popup.popupLine.backgroundColor = Colors.orange
                self.popup.popupFavoriteButton.tintColor = Colors.orange
                self.popup.popupIcon.tintColor = Colors.orange
            } else {
                self.popup.layer.borderColor = Colors.red.cgColor
                self.popup.popupLine.backgroundColor = Colors.red
                self.popup.popupFavoriteButton.tintColor = Colors.red
                self.popup.popupIcon.tintColor = Colors.red
            }
            
            self.popup.lat = i.lat
            self.popup.lng = i.lng
            self.popup.popupText.text = i.title
            
            if i.info == "" {
                self.popup.popupInfo.text = "24시간"
            } else {
                self.popup.popupInfo.text = i.info
            }
            self.popup.id = i.id
            self.show()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func favoriteDataSend(_ notification: Notification) {
        let value = notification.object as! UserMap
        self.markerDelete()
        Marker.markers.removeAll()
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: value.lat, lng: value.lng), zoomTo: 15)
        cameraUpdate.animation = .easeIn
        self.mapView.moveCamera(cameraUpdate)
        
        let southWest = NMGLatLng(lat: value.lat - value.lat/4000, lng: value.lng - value.lng/4000)
        let northEast = NMGLatLng(lat: value.lat + value.lat/4000, lng: value.lng + value.lng/4000)
        Bound.shared.bounds = NMGLatLngBounds(southWest: southWest, northEast: northEast)
        self.makeMarker(bound: Bound.shared.bounds!)
        self.view.addSubview(self.popup)
        self.popup.isHidden = false
        
        if value.type == 0 {
            self.popup.layer.borderColor = Colors.green.cgColor
            self.popup.popupLine.backgroundColor = Colors.green
            self.popup.popupFavoriteButton.tintColor = Colors.green
            self.popup.popupIcon.tintColor = Colors.green
        } else if value.type == 1 {
            self.popup.layer.borderColor = Colors.orange.cgColor
            self.popup.popupLine.backgroundColor = Colors.orange
            self.popup.popupFavoriteButton.tintColor = Colors.orange
            self.popup.popupIcon.tintColor = Colors.orange
        } else {
            self.popup.layer.borderColor = Colors.red.cgColor
            self.popup.popupLine.backgroundColor = Colors.red
            self.popup.popupFavoriteButton.tintColor = Colors.red
            self.popup.popupIcon.tintColor = Colors.red
        }
        
        value.favorite ? self.popup.popupFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : self.popup.popupFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        self.popup.lat = value.lat
        self.popup.lng = value.lng
        self.popup.popupText.text = value.title
        if value.info == "" {
            self.popup.popupInfo.text = "24시간"
        } else {
            self.popup.popupInfo.text = value.info
        }
        self.popup.id = value.id
        self.show()
    }
}

extension ViewController {
    //권한 요청
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        authorizationStatus = locationManager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스 꺼짐")
        }
    }
    
    //권한 체크
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            //주의점: infoPlist WhenInUse -> request 메서드 OK
            //kCLLocationAccuracyBest 각각 디바이스에 맞는 정확도로 설정해줌
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            
            //설정까지 이동하거나 설정 세부화면까지 이동하거나
            //한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 - 설정
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
            
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {
    //위치를 성공적으로 가지고 온 경우 실행
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //내위치 가져오기
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 10000
        guard let lat = locationManager.location?.coordinate.latitude else { return }
        guard let lng = locationManager.location?.coordinate.longitude else { return }
        print("내위치", lat, lng)
        locationManager.stopUpdatingLocation()
        //내위치를 카메라로 보여주기
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
        //내위치 중심으로 바운더리 설정
        let southWest = NMGLatLng(lat: lat - lat/4000, lng: lng - lng/4000)
        let northEast = NMGLatLng(lat: lat + lat/4000, lng: lng + lng/4000)
        Bound.shared.bounds = NMGLatLngBounds(southWest: southWest, northEast: northEast)
        //바운드에 맞는 마커들 가져오기
        makeMarker(bound: Bound.shared.bounds!)
        markerCluster()
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

extension ViewController: NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
    
    //지도 움직일때마다 자동으로 실행
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        markerDelete()
        Marker.markers.removeAll()
        let cameraPosition = mapView.cameraPosition.target
        let southWest = NMGLatLng(lat: cameraPosition.lat - cameraPosition.lat/4000, lng: cameraPosition.lng - cameraPosition.lng/4000)
        let northEast = NMGLatLng(lat: cameraPosition.lat + cameraPosition.lat/4000, lng: cameraPosition.lng + cameraPosition.lng/4000)
        Bound.shared.bounds = NMGLatLngBounds(southWest: southWest, northEast: northEast)
        makeMarker(bound: Bound.shared.bounds!)
        markerCluster()
    }
    
    //지도 탭하면 실행
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        self.popup.isHidden = true
        self.main.locationButton.snp.remakeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-60)
            $0.trailing.equalTo(-20)
            $0.height.width.equalTo(44)
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: { self.view.layoutIfNeeded() }
        )
        
        if let marker = self.mark {
            if marker.userInfo["type"] as! Int == 0 {
                marker.iconImage = NMFOverlayImage(name: "loc1")
            } else if marker.userInfo["type"] as! Int == 1 {
                marker.iconImage = NMFOverlayImage(name: "loc2")
            } else {
                marker.iconImage = NMFOverlayImage(name: "loc3")
            }
        }
    }
    
    //바운드에 맞게 마커 생성
    func makeMarker(bound: NMGLatLngBounds) {
        
        for i in MapRepository.shared.tasks {
            let marker = NMFMarker()
            if bound.hasPoint(NMGLatLng(lat: i.lat, lng: i.lng)) {
                marker.position = NMGLatLng(lat: i.lat, lng: i.lng)
            }
            
            marker.userInfo = ["type":i.type]
            
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self else { return false }
                
                if let marker = self.mark {
                    if marker.userInfo["type"] as! Int == 0 {
                        marker.iconImage = NMFOverlayImage(name: "loc1")
                    } else if marker.userInfo["type"] as! Int == 1 {
                        marker.iconImage = NMFOverlayImage(name: "loc2")
                    } else {
                        marker.iconImage = NMFOverlayImage(name: "loc3")
                    }
                }
                
                if marker.userInfo["type"] as! Int == 0 {
                    marker.iconImage = NMFOverlayImage(name: "loc4")
                } else if marker.userInfo["type"] as! Int == 1 {
                    marker.iconImage = NMFOverlayImage(name: "loc5")
                } else {
                    marker.iconImage = NMFOverlayImage(name: "loc6")
                }
                
                self.mark = marker
                
                self.view.addSubview(self.popup)
                self.popup.isHidden = false
                
                i.favorite ? self.popup.popupFavoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal) : self.popup.popupFavoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                
                self.popup.lat = i.lat
                self.popup.lng = i.lng
                self.popup.popupText.text = "\(i.id). \(i.title)"
                if i.info == "" {
                    self.popup.popupInfo.text = "24시간"
                } else {
                    self.popup.popupInfo.text = i.info
                }
                
                self.popup.id = i.id
                
                if marker.userInfo["type"] as! Int == 0 {
                    self.popup.layer.borderColor = Colors.green.cgColor
                    self.popup.popupLine.backgroundColor = Colors.green
                    self.popup.popupFavoriteButton.tintColor = Colors.green
                    self.popup.popupIcon.tintColor = Colors.green
                } else if marker.userInfo["type"] as! Int == 1 {
                    self.popup.layer.borderColor = Colors.orange.cgColor
                    self.popup.popupLine.backgroundColor = Colors.orange
                    self.popup.popupFavoriteButton.tintColor = Colors.orange
                    self.popup.popupIcon.tintColor = Colors.orange
                } else {
                    self.popup.layer.borderColor = Colors.red.cgColor
                    self.popup.popupLine.backgroundColor = Colors.red
                    self.popup.popupFavoriteButton.tintColor = Colors.red
                    self.popup.popupIcon.tintColor = Colors.red
                }
                
                self.show()
                
                return true
            }
            
            marker.width = 44
            marker.height = 44
            
            if i.type == 0 {
                marker.iconImage = NMFOverlayImage(name: "loc1")
            } else if i.type == 1 {
                marker.iconImage = NMFOverlayImage(name: "loc2")
            } else {
                marker.iconImage = NMFOverlayImage(name: "loc3")
            }
            Marker.markers.append(marker)
        }
        
        DispatchQueue.main.async {
            if self.main.downButton.currentTitle == "공기주입기" {
                self.markerDelete()
                self.markerAdd(0)
            } else if self.main.downButton.currentTitle == "자전거 거치대" {
                self.markerDelete()
                self.markerAdd(1)
            } else if self.main.downButton.currentTitle == "자전거 수리시설" {
                self.markerDelete()
                self.markerAdd(2)
            } else {
                self.markerAdd(3)
            }
            
            self.main.dropDown.selectionAction = { (index, item) in
                self.main.downButton.setTitle(item, for: .normal)
                if index == 0 {
                    self.markerAdd(3)
                } else if index == 1 {
                    self.markerDelete()
                    self.markerAdd(0)
                } else if index == 2 {
                    self.markerDelete()
                    self.markerAdd(1)
                } else {
                    self.markerDelete()
                    self.markerAdd(2)
                }
            }
        }
    }
}






