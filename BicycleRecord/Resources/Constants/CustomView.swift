//
//  CustomView.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import Foundation

import UIKit

import SnapKit

class CustomView: UIView {
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    let componentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        [iconImage, componentLabel, statusLabel].forEach { self.addSubview($0) }
        
        iconImage.snp.makeConstraints { make in
            make.leading.top.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(self).multipliedBy(0.25)
        }
        
        componentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(iconImage.snp.bottom).offset(8)
            make.height.equalTo(self).multipliedBy(0.2)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(componentLabel.snp.bottom)
            make.height.equalTo(self).multipliedBy(0.2)            
        }
    }
    
}
