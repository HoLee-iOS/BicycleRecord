//
//  MapView.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import CoreLocation
import NMapsMap
import SnapKit
import DropDown

class MainView: BaseView {
    
    lazy var mapview = NMFMapView(frame: self.frame)
    
    let downButton: UIButton = {
        let button = UIButton()
        button.setTitle(" 모든 편의시설 ", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle.dashed.inset.filled"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        return button
    }()
    
    let dropDown = DropDown()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [mapview, downButton, locationButton].forEach {
            self.addSubview($0)
        }
        
        dropDown.dataSource = [" 모든 편의시설 ", " 공기주입기 ", " 자전거 거치대 ", " 자전거 수리시설 "]
        dropDown.anchorView = downButton
        dropDown.cornerRadius = 10
    }
    
    override func setConstraints() {
        mapview.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        downButton.snp.makeConstraints { make in
            make.centerX.equalTo(mapview)
            make.top.equalTo(mapview).inset(20)
        }
        
        locationButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-60)
            make.trailing.equalTo(-20)
            make.height.width.equalTo(44)
        }
    }
}

