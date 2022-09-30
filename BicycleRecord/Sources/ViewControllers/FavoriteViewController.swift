//
//  FavoriteViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import RealmSwift

class FavoriteViewController: BaseViewController {
    
    let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "즐겨찾기가 없습니다."
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 200
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteTableViewCell.reuseIdentifier)
        return view
    }()
    
    var info = MapRepository.shared.filterFavorite()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapRepository.shared.fetch()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        info = MapRepository.shared.filterFavorite()        
        tableView.reloadData()
        
        emptyCheck()
    }
    
    override func configure() {
        [emptyView, emptyLabel, tableView].forEach {
            view.addSubview($0)
        }        
    }
    
    override func setConstraints() {
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(emptyView)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func route(_ sender: UIButton) {
        let index = sender.tag
        let info = MapRepository.shared.filterFavorite()
        let lat = info?[index].lat
        let lng = info?[index].lng
        let text = info?[index].title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: "nmap://route/walk?dlat=\(lat!)&dlng=\(lng!)&dname=\(text!)&appname=com.skylerLee.Example1")!
        let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8")!
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    @objc func favorite(_ sender: UIButton) {
        let index = sender.tag
        let info = MapRepository.shared.filterFavorite()
        MapRepository.shared.updateFavorite(item: (info?[index])!)
        tableView.reloadData()
        showToastMessage("즐겨찾기에서 삭제되었습니다")
        emptyCheck()
    }
    
    func emptyCheck() {
        if info?.count ?? 0 == 0 {
            tableView.isHidden = true
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
        }
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = MapRepository.shared.filterFavorite()
        return info?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier) as? FavoriteTableViewCell else { return UITableViewCell() }
        
        if info?[indexPath.row].type == 0 {
            cell.popup.layer.borderColor = Colors.green.cgColor
            cell.popup.popupLine.backgroundColor = Colors.green
            cell.popup.popupFavoriteButton.tintColor = Colors.green
            cell.popup.popupIcon.tintColor = Colors.green
        } else if info?[indexPath.row].type == 1 {
            cell.popup.layer.borderColor = Colors.orange.cgColor
            cell.popup.popupLine.backgroundColor = Colors.orange
            cell.popup.popupFavoriteButton.tintColor = Colors.orange
            cell.popup.popupIcon.tintColor = Colors.orange
        } else {
            cell.popup.layer.borderColor = Colors.red.cgColor
            cell.popup.popupLine.backgroundColor = Colors.red
            cell.popup.popupFavoriteButton.tintColor = Colors.red
            cell.popup.popupIcon.tintColor = Colors.red
        }
        
        cell.popup.popupText.text = info?[indexPath.row].title
        
        if info?[indexPath.row].info == "" {
            cell.popup.popupInfo.text = "24시간"
        } else {
            cell.popup.popupInfo.text = info?[indexPath.row].info
        }
        
        cell.popup.popupSearchButton.tag = indexPath.row
        cell.popup.popupSearchButton.addTarget(self, action: #selector(route), for: .touchUpInside)
        
        cell.popup.popupFavoriteButton.tag = indexPath.row
        cell.popup.popupFavoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        
        let image = info?[indexPath.row].favorite ?? false ? "star.fill" : "star"
        cell.popup.popupFavoriteButton.setImage(UIImage(systemName: image), for: .normal)
        
        emptyCheck()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = MapRepository.shared.filterFavorite()
        NotificationCenter.default.post(name: Notification.Name("data"), object: info?[indexPath.row])
        self.tabBarController?.selectedIndex = 0
    }
}

