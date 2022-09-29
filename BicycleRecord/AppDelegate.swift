//
//  AppDelegate.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //앱 실행시 네트워크 상태 확인
        NetworkMonitor.shared.startMonitoring()
        
        if !NetworkMonitor.shared.isConnected {
            self.window?.rootViewController?.present(NetworkMonitor.shared.showAlert(), animated: true)
        }
        
        let group = DispatchGroup()
        
        if MapRepository.shared.tasks.isEmpty || MapRepository.shared.tasks.count > UserDefaults.standard.integer(forKey: "cnt") {
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
                group.leave()
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
                group.leave()
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
        
        window = UIWindow()
        window?.rootViewController = TabBarViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

