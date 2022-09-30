//
//  LaunchViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/30.
//

import UIKit

import Lottie
import Toast

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView: AnimationView = .init(name: "ricle")
        self.view.addSubview(animationView)
        
        animationView.frame = self.view.bounds
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        
        animationView.play { _ in
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let vc = TabBarViewController()
            
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        }
        
        if UserDefaults.standard.bool(forKey: "First") {
            animationView.loopMode = .playOnce
        } else {
            animationView.loopMode = .repeat(3)
            let group = DispatchGroup()
            //1회
            group.enter()
            BicycleAPIManager.shared.callRequest(startIndex: 1, endIndex: 1000) { loc, count  in
                UserDefaults.standard.set(count, forKey: "cnt")
                UserDefaults.standard.set(true, forKey: "First")
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
            //2회
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
            //3회
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
}
