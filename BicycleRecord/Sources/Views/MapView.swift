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
        button.setTitle("모든 편의시설", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        //shadow 설정
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
        return button
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle.dashed.inset.filled"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .black
        return button
    }()
    
    lazy var dropDown: DropDown = {
        let drop = DropDown()
        drop.cellHeight = 40
        drop.width = 120
        drop.dataSource = ["모든 편의시설", "공기주입기", "자전거 거치대", "자전거 수리시설"]
        drop.anchorView = downButton
        drop.cornerRadius = 10
        drop.textFont = .systemFont(ofSize: 12)
        //shadow 설정
        drop.layer.shadowColor = UIColor.black.cgColor
        drop.layer.shadowOpacity = 0.5
        drop.layer.shadowOffset = .zero
        drop.layer.shadowRadius = 10
        return drop
    }()
    
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
        
        dropDown.cellNib = UINib(nibName: "DropCell", bundle: nil)
        dropDown.customCellConfiguration = { index, title, cell in
            
            guard let cell = cell as? DropCell else { return }
            
            if index == 1 {
                cell.colorCircles.image = UIImage(systemName: "circle.fill")
                cell.colorCircles.tintColor = Colors.first
            } else if index == 2 {
                cell.colorCircles.image = UIImage(systemName: "circle.fill")
                cell.colorCircles.tintColor = Colors.second
            } else if index == 3 {
                cell.colorCircles.image = UIImage(systemName: "circle.fill")
                cell.colorCircles.tintColor = Colors.third
            }
        }
    }
    
    override func setConstraints() {
        mapview.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        downButton.snp.makeConstraints { make in
            make.centerX.equalTo(mapview)
            make.top.equalTo(mapview).inset(20)
            make.width.equalTo(120)
        }
        
        locationButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-60)
            make.trailing.equalTo(-20)
            make.height.width.equalTo(44)
        }
    }
}

