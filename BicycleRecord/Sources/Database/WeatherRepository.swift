//
//  WeatherRepository.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import Foundation

import RealmSwift

class WeatherRepository {
    
    private init () { }
    static let shared = WeatherRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<UserWeather>!
    
    func fetch() {
        tasks = localRealm.objects(UserWeather.self)
    }
    
    //MARK: 날씨 정보 저장
    func saveRealm(item: UserWeather) {
        do {
            try localRealm.write {
                localRealm.add(item)
            }
            tasks = localRealm.objects(UserWeather.self)
        }
        catch let error {
            print(error)
        }
    }
    
    //MARK: 날씨 정보 삭제
    func deleteItem(item: UserWeather) {
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
}
