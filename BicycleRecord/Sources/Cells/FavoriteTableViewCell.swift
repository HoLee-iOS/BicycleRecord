//
//  FavoriteTableViewCell.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import SnapKit

class FavoriteTableViewCell: BaseTableViewCell {
    
    let popup = PopUpView()
    
    override func configure() {
        self.backgroundColor = .white
        
        //MARK: 테이블뷰셀에서 뷰를 추가해줄때는 반드시 contentView에 추가해줘야함
        contentView.addSubview(popup)
    }
    
    override func setConstraints() {
        popup.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(10)
        }
    }
}

