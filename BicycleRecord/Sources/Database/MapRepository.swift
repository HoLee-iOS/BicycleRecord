//
//  MapRepository.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import Foundation

import RealmSwift

class MapRepository {
    
    private init () { }
    static let shared = MapRepository()
    
    let localRealm = try! Realm()
    var tasks: Results<UserMap>!
    
    func fetch() {
        tasks = localRealm.objects(UserMap.self)
    }
    
    //MARK: 편의시설 정보 저장
    func saveRealm(item: UserMap) {
        do {
            try localRealm.write {
                localRealm.add(item)
            }
            tasks = localRealm.objects(UserMap.self)
        }
        catch let error {
            print(error)
        }
    }
    
    //MARK: 즐겨찾기 업데이트 기능
    func updateFavorite(item: UserMap) {
        try! localRealm.write {
            item.favorite.toggle()
            print("Realm Update")
        }
        tasks = localRealm.objects(UserMap.self)
    }
    

    func filterFavorite() -> Results<UserMap>? {
        return tasks?.where { $0.favorite == true } ?? nil
    }
}
