//
//  PopupView.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import SnapKit
import RealmSwift

class PopUpView: BaseView {
    
    var lat: Double?
    var lng: Double?
    
    var id: Int?
    
    let popupText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let popupInfo: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let popupLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var popupFavoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        return button
    }()
    
    let popupSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("길찾기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    override func configure() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 3
        
        [popupText, popupInfo, popupLine, popupFavoriteButton, popupSearchButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        popupText.snp.makeConstraints { make in
            make.leading.top.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        popupInfo.snp.makeConstraints { make in
            make.top.equalTo(popupText.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        popupLine.snp.makeConstraints { make in
            make.top.equalTo(popupInfo.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(1)
        }
        
        popupFavoriteButton.snp.makeConstraints { make in
            make.top.equalTo(popupLine.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.bottom.equalTo(-20)
        }
        
        popupSearchButton.snp.makeConstraints { make in
            make.top.equalTo(popupLine.snp.bottom).offset(20)
            make.trailing.bottom.equalTo(-20)
        }
        
    }
}

