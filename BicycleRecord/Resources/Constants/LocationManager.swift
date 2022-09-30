//
//  LocationManager.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/30.
//

//추후 Refactoring시에 사용 예정
//import Foundation
//import UIKit
//import CoreLocation
//
//class LocationManager: CLLocationManager {
//
//    private override init () { }
//
//    static let shared = LocationManager()
//
//    //권한 요청
//    func checkUserDeviceLocationServiceAuthorization(_ vc: UIViewController) {
//        let authorizationStatus: CLAuthorizationStatus
//
//        authorizationStatus = LocationManager.shared.authorizationStatus
//
//        if CLLocationManager.locationServicesEnabled() {
//            checkUserCurrentLocationAuthorization(authorizationStatus, vc)
//        } else {
//            print("위치 서비스 꺼짐")
//        }
//    }
//
//    //권한 체크
//    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus, _ vc: UIViewController) {
//        switch authorizationStatus {
//        case .notDetermined:
//            //주의점: infoPlist WhenInUse -> request 메서드 OK
//            //kCLLocationAccuracyBest 각각 디바이스에 맞는 정확도로 설정해줌
//            LocationManager.shared.desiredAccuracy = kCLLocationAccuracyBest
//            //앱을 사용하는 동안에 권한에 대한 위치 권한 요청
//            LocationManager.shared.requestWhenInUseAuthorization()
//        case .restricted ,.denied:
//            print("DENIED")
//            showRequestLocationServiceAlert(vc)
//        case .authorizedWhenInUse:
//            print("WHEN IN USE")
//            //사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
//            LocationManager.shared.startUpdatingLocation() //단점: 정확도를 위해서 무한대로 호출됨
//        default: print("디폴트")
//        }
//    }
//
//    //권한 거부시 경고창
//    func showRequestLocationServiceAlert(_ vc: UIViewController) {
//        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
//        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
//
//            //설정까지 이동하거나 설정 세부화면까지 이동하거나
//            //한 번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나 - 설정
//            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(appSetting)
//            }
//
//        }
//        let cancel = UIAlertAction(title: "취소", style: .default)
//        requestLocationServiceAlert.addAction(cancel)
//        requestLocationServiceAlert.addAction(goSetting)
//
//        vc.present(requestLocationServiceAlert, animated: true, completion: nil)
//    }
//
//}
