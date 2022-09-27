//
//  WeatherView.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import Kingfisher
import RealmSwift

class WeatherView: BaseView {
    
    let weatherImage: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    let currentTemp: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 35, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let todayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let infoBack: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.grey
        view.layer.cornerRadius = 10
        return view
    }()
    
    let infoStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 16
        return view
    }()
    
    lazy var mise: CustomView = {
        makeCustom(icon: "aqi.medium", component: "미세")
    }()
    
    lazy var choMise: CustomView = {
        makeCustom(icon: "aqi.low", component: "초미세")
    }()
    
    lazy var rainy: CustomView = {
        makeCustom(icon: "drop", component: "강수확률")
    }()
    
    lazy var windy: CustomView = {
        makeCustom(icon: "wind", component: "바람")
    }()
    
    override func configure() {
        [mise, choMise, rainy, windy].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        [weatherImage, currentTemp, todayLabel, infoBack, infoStackView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        weatherImage.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.height.width.equalTo(150)
        }
        
        currentTemp.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(weatherImage.snp.bottom).offset(8)
        }
        
        todayLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(currentTemp.snp.bottom).offset(16)
        }
        
        infoBack.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(todayLabel.snp.bottom).offset(50)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(180)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(infoBack).inset(25)
            make.trailing.equalTo(infoBack).inset(25)
            make.top.equalTo(infoBack).inset(16)
            make.bottom.equalTo(infoBack).inset(16)
        }
    }
    
    func makeCustom(icon: String, component: String) -> CustomView {
        let view = CustomView()
        view.iconImage.image = UIImage(systemName: icon)
        view.iconImage.tintColor = .black
        
        view.componentLabel.text = component
        view.componentLabel.font = .systemFont(ofSize: 12.5, weight: .semibold)
        view.componentLabel.textColor = .gray
        view.componentLabel.textAlignment = .center
        
        view.statusLabel.font = .systemFont(ofSize: 12.5, weight: .semibold)
        view.statusLabel.textColor = .black
        view.statusLabel.textAlignment = .center
        return view
    }
}

