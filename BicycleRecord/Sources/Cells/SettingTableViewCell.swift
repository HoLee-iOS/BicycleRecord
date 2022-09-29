//
//  SettingTableViewCell.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/29.
//

import Foundation
import UIKit

class SettingTableViewCell: BaseTableViewCell {
    
    let setTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        contentView.addSubview(setTitle)
    }
    
    override func setConstraints() {
        setTitle.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(20)
        }
    }
}
