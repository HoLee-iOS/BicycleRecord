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
    
    let popupIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "circle.fill")
        return image
    }()
    
    let popupText: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let popupInfo: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let popupLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
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
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    override func configure() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        
        [popupIcon, popupText, popupInfo, popupLine, popupFavoriteButton, popupSearchButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        popupIcon.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.top.equalTo(22)
            make.height.width.equalTo(15)
        }
        
        popupText.snp.makeConstraints { make in
            make.centerY.equalTo(popupIcon.snp.centerY)
            make.leading.equalTo(popupIcon.snp.trailing).offset(10)
            make.trailing.equalTo(-20)
        }
        
        popupInfo.snp.makeConstraints { make in
            make.top.equalTo(popupIcon.snp.bottom).offset(4)
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
            make.top.equalTo(popupLine.snp.bottom).offset(16)
            make.leading.equalTo(20)
            make.bottom.equalTo(-20)
        }
        
        popupSearchButton.snp.makeConstraints { make in
            make.centerY.equalTo(popupFavoriteButton.snp.centerY)
            make.trailing.bottom.equalTo(-20)
        }
        
    }
}

