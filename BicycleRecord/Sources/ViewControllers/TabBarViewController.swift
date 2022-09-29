//
//  TabBarViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import RealmSwift

class TabBarViewController: UITabBarController {
    
    let mapVC = ViewController()
    let favoriteVC = FavoriteViewController()
    let weatherVC = WeatherViewController()
    let setVC = SettingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapVC.title = "지도"
        favoriteVC.title = "즐겨찾기"
        weatherVC.title = "날씨"
        setVC.title = "설정"
        
        mapVC.tabBarItem.image = UIImage(systemName: "map")
        favoriteVC.tabBarItem.image = UIImage(systemName: "star")
        weatherVC.tabBarItem.image = UIImage(systemName: "cloud.sun")
        setVC.tabBarItem.image = UIImage(systemName: "gearshape")
        
        let navMap = UINavigationController(rootViewController: mapVC)
        let navFav = UINavigationController(rootViewController: favoriteVC)
        let navWea = UINavigationController(rootViewController: weatherVC)
        let navSet = UINavigationController(rootViewController: setVC)
        
        setViewControllers([navWea, navMap, navFav, navSet], animated: false)
        
        tabBar.tintColor = .black
        
        self.selectedIndex = 1
    }
}

