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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapVC.title = "지도"
        favoriteVC.title = "즐겨찾기"
        weatherVC.title = "날씨"
        
        mapVC.tabBarItem.image = UIImage(systemName: "map")
        favoriteVC.tabBarItem.image = UIImage(systemName: "star")
        weatherVC.tabBarItem.image = UIImage(systemName: "cloud.sun")
        
//        mapVC.navigationItem.largeTitleDisplayMode = .always
//        favoriteVC.navigationItem.largeTitleDisplayMode = .always
//        weatherVC.navigationItem.largeTitleDisplayMode = .always
        
        let navMap = UINavigationController(rootViewController: mapVC)
        let navFav = UINavigationController(rootViewController: favoriteVC)
        let navWea = UINavigationController(rootViewController: weatherVC)
        
//        navMap.navigationBar.prefersLargeTitles = true
//        navFav.navigationBar.prefersLargeTitles = true
//        navWea.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navWea, navMap, navFav], animated: false)
        
        tabBar.tintColor = .black
        
        self.selectedIndex = 1
    }
}

