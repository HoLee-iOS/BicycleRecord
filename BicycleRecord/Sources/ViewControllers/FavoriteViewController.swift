//
//  FavoriteViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import RealmSwift

class FavoriteViewController: BaseViewController {
    
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
    }
    
    override func configure() {
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
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
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = MapRepository.shared.filterFavorite()
        return info?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.reuseIdentifier) as? FavoriteTableViewCell else { return UITableViewCell() }
        
        cell.popup.popupText.text = info?[indexPath.row].title
        cell.popup.popupInfo.text = info?[indexPath.row].info
        
        cell.popup.popupSearchButton.tag = indexPath.row
        cell.popup.popupSearchButton.addTarget(self, action: #selector(route), for: .touchUpInside)
        
        cell.popup.popupFavoriteButton.tag = indexPath.row
        cell.popup.popupFavoriteButton.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        
        let image = info?[indexPath.row].favorite ?? false ? "star.fill" : "star"
        cell.popup.popupFavoriteButton.setImage(UIImage(systemName: image), for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = MapRepository.shared.filterFavorite()
        NotificationCenter.default.post(name: Notification.Name("data"), object: info?[indexPath.row])
        self.tabBarController?.selectedIndex = 1
    }
}

