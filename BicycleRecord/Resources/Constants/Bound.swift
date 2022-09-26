//
//  Bound.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import Foundation

import NMapsMap

class Bound {
    
    static let shared = Bound()
    
    private init() {}
    
    var bounds: NMGLatLngBounds?
}
