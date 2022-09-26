//
//  SearchTableViewCell.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import SnapKit

class SearchTableViewCell: BaseTableViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let address: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    override func configure() {
        self.backgroundColor = .white
        
        [title, address].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        title.snp.makeConstraints { make in
            make.top.leading.equalTo(20)
        }
        address.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.leading.equalTo(20)
        }
    }
    
}

