//
//  SearchTableViewCell.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import SnapKit

class SearchTableViewCell: BaseTableViewCell {
    
    let icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "circle.fill")
        return image
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    let address: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    override func configure() {
        self.backgroundColor = .white
        
        [icon, title, address].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        icon.snp.makeConstraints { make in
            make.top.leading.equalTo(20)
            make.height.width.equalTo(15)
        }
        
        title.snp.makeConstraints { make in
            make.centerY.equalTo(icon)
            make.leading.equalTo(icon.snp.trailing).offset(8)
        }
        address.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(8)
            make.leading.equalTo(20)
        }
    }
    
}

