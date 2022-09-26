//
//  BicycleAPIManager.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import Foundation

import Alamofire
import SwiftyJSON

class BicycleAPIManager {
    
    static let shared = BicycleAPIManager()
    
    private init() {}
    
    func callRequest(startIndex: Int, endIndex: Int, completion: @escaping ([(Double, Double, String, String, Int, String)], Int) -> ()) {
        let url = "http://openapi.seoul.go.kr:8088/\(APIKey.bicycle)/json/tvBicycleEtc/\(startIndex)/\(endIndex)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let loc = json["tvBicycleEtc"]["row"].arrayValue.map { (Double($0["COT_COORD_Y"].stringValue)!, Double($0["COT_COORD_X"].stringValue)!, $0["COT_CONTS_NAME"].stringValue, $0["COT_VALUE_01"].stringValue, Int($0["RNUM"].stringValue)!, $0["COT_ADDR_FULL_NEW"].stringValue) }
                
                let count = json["tvBicycleEtc"]["list_total_count"].intValue
                
                completion(loc, count)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
