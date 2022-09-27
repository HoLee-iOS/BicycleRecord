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
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let todayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    let infoBack: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    let infoStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    lazy var mise: CustomView = {
        makeCustom(icon: "sun.haze", component: "미세")
    }()
    
    lazy var choMise: CustomView = {
        makeCustom(icon: "sun.dust", component: "초미세")
    }()
    
    lazy var rainy: CustomView = {
        makeCustom(icon: "sun.max", component: "강수확률")
    }()
    
    lazy var windy: CustomView = {
        makeCustom(icon: "drop", component: "바람")
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
            make.height.width.equalTo(100)
        }
        
        currentTemp.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(weatherImage.snp.bottom).offset(20)
            make.leading.equalTo(60)
            make.trailing.equalTo(-60)
            make.height.equalTo(44)
        }
        
        todayLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(currentTemp.snp.bottom).offset(20)
            make.leading.equalTo(60)
            make.trailing.equalTo(-60)
            make.height.equalTo(44)
        }
        
        infoBack.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(todayLabel.snp.bottom).offset(50)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(200)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.edges.equalTo(infoBack).inset(20)
        }
    }
    
    func makeCustom(icon: String, component: String) -> CustomView {
        let view = CustomView()
        view.iconImage.image = UIImage(systemName: icon)
        view.iconImage.tintColor = .black
        view.componentLabel.text = component
        view.componentLabel.textColor = .gray
        view.componentLabel.textAlignment = .center
        view.componentLabel.font = .systemFont(ofSize: 12, weight: .bold)
        view.statusLabel.font = .systemFont(ofSize: 12, weight: .bold)
        view.statusLabel.textColor = .black
        view.statusLabel.textAlignment = .center
        return view
    }
}

