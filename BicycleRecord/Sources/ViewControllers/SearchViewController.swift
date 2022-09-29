//
//  SearchViewController.swift
//  BicycleRecord
//
//  Created by 이현호 on 2022/09/27.
//

import UIKit

import RealmSwift

class SearchViewController: BaseViewController {
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "편의시설이나 도로명 주소를 입력해 주세요."
        bar.delegate = self
        return bar
    }()
    
    let emptyView: UIView = {
        let view = UIView()
        return view
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "검색결과가 없습니다."
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 75
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        return view
    }()
    
    var selectRow: ((UserMap?)->())?
    
    var filteredArr: Results<UserMap>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapRepository.shared.fetch()
        view.backgroundColor = .white
        
        self.navigationItem.title = "검색"
        self.navigationController?.navigationBar.tintColor = .black
        
        emptyCheck()
    }
    
    override func configure() {
        [searchBar, emptyView, emptyLabel, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(emptyView)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func emptyCheck() {
        if filteredArr?.count ?? 0 == 0 {
            tableView.isHidden = true
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
            tableView.isHidden = false
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let text = searchText.lowercased()
        
        filteredArr = MapRepository.shared.tasks.where { $0.title.contains(text, options: .caseInsensitive) || $0.address.contains(text, options: .caseInsensitive) }
        
        emptyCheck()
        
        tableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier) as? SearchTableViewCell else { return UITableViewCell() }
        
        guard let arr = filteredArr else { return UITableViewCell() }
        
        if arr[indexPath.row].type == 0 {
            cell.icon.tintColor = Colors.green
        } else if arr[indexPath.row].type == 1 {
            cell.icon.tintColor = Colors.orange
        } else {
            cell.icon.tintColor = Colors.red
        }
        
        cell.title.text = "\(arr[indexPath.row].id). \(arr[indexPath.row].title)"
        
        if arr[indexPath.row].address == "" {
            cell.address.text = ""
        } else {
            cell.address.text = arr[indexPath.row].address
        }
        
        emptyCheck()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow?(filteredArr?[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}

