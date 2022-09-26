//
//  WeatherRealm.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import Foundation

import RealmSwift

class UserWeather: Object {
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    @Persisted var main: String //날씨 종류
    @Persisted var icon: String //날씨 아이콘
    @Persisted var temp: String //현재 기온
    @Persisted var windPower: Double //풍속
    @Persisted var rain: Int //깅수 확률
    @Persisted var mise: Double //미세먼지
    @Persisted var choMise: Double //초미세먼지
    @Persisted var time = Date() //시간
    
    convenience init(main: String, icon: String, temp: String, windPower: Double, rain: Int, mise: Double, choMise: Double, time: Date) {
        self.init()
        self.main = main
        self.icon = icon
        self.temp = temp
        self.rain = rain
        self.windPower = windPower
        self.mise = mise
        self.choMise = choMise
        self.time = time
    }
    
}

