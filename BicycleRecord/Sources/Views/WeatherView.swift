//
//  WeatherView.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import Kingfisher

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
        label.font = .systemFont(ofSize: 20, weight: .medium)
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
    
    let bottomBack: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.grey
        view.layer.cornerRadius = 10
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "*날씨 예보 및 데이터 반영주기에 따라 실제 날씨와 \n 상이할 수 있습니다. \n 제공: OpenWeather \n 기준: WHO(세계보건기구)"
        label.textColor = Colors.blue
        label.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: label.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override func configure() {
        [mise, choMise, rainy, windy].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        [weatherImage, currentTemp, todayLabel, infoBack, infoStackView, bottomBack, infoLabel].forEach {
            self.addSubview($0)
        }
        
        colorString(label: infoLabel, colorStr: "제공: OpenWeather \n 기준: WHO(세계보건기구)", color: .gray)
    }
    
    override func setConstraints() {
        weatherImage.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.25)
            make.width.equalTo(weatherImage.snp.height)
        }
        
        currentTemp.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(weatherImage.snp.bottom).offset(16)
        }
        
        todayLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(currentTemp.snp.bottom).offset(16)
        }
        
        infoBack.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(todayLabel.snp.bottom).offset(16)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.2)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(infoBack).inset(25)
            make.top.bottom.equalTo(infoBack).inset(8)
        }
        
        bottomBack.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(infoBack.snp.bottom).offset(16)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.2)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(bottomBack).inset(15)
            make.top.bottom.equalTo(bottomBack)
        }
    }
    
    func makeCustom(icon: String, component: String) -> CustomView {
        let view = CustomView()
        view.iconImage.image = UIImage(systemName: icon)
        view.iconImage.tintColor = .black
        
        view.componentLabel.text = component
        view.componentLabel.font = .systemFont(ofSize: 13, weight: .bold)
        view.componentLabel.textColor = .black
        view.componentLabel.textAlignment = .center
        
        view.statusLabel.font = .systemFont(ofSize: 13, weight: .bold)
        view.statusLabel.textColor = Colors.blue
        view.statusLabel.textAlignment = .center
        return view
    }
}

