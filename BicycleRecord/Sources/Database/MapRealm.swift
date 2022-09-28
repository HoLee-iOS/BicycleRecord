//
//  MapRealm.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import Foundation

import RealmSwift

class UserMap: Object {
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    @Persisted var lat: Double
    @Persisted var lng: Double
    @Persisted var title: String
    @Persisted var info: String?
    @Persisted var id: Int
    @Persisted var address: String
    @Persisted var type: Int
    @Persisted var favorite: Bool
    
    convenience init(lat: Double, lng: Double, title: String, info: String?, id: Int, address: String, type: Int) {
        self.init()
        self.lat = lat
        self.lng = lng
        self.title = title
        self.info = info
        self.id = id
        self.address = address
        self.type = type
        self.favorite = false
    }
    
}
