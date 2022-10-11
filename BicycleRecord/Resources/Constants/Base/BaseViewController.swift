//
//  BaseViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit
import CoreLocation
import FirebaseAnalytics

import Toast

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //이벤트 로깅
        Analytics.logEvent("Ricle", parameters: [
          "name": "Ricle",
          "full_text": "Ricle Analytics",
        ])
        
        //기본 이벤트 매개변수 설정
        Analytics.setDefaultEventParameters([
          "level_name": "Caverns01",
          "level_difficulty": 4
        ])
        
        configure()
        setConstraints()
    }
    
    func configure() { }
    
    func setConstraints() { }
    
    func showToastMessage(_ message: String) {
        self.view.makeToast(message, position: .bottom)
    }
}

