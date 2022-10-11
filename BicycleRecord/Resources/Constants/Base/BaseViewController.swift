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
        
        configure()
        setConstraints()
    }
    
    func configure() { }
    
    func setConstraints() { }
    
    func showToastMessage(_ message: String) {
        self.view.makeToast(message, position: .bottom)
    }
}

