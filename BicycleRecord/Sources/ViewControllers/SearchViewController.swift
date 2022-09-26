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
        bar.placeholder = "편의시설을 검색해주세요"
        bar.delegate = self
        return bar
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 80
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        return view
    }()
    
    var filteredArr: Results<UserMap>?
    
    var tasks = MapRepository.shared.tasks!
    
    var selectRow: ((UserMap?)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapRepository.shared.fetch()
        view.backgroundColor = .white
    }
    
    override func configure() {
        [searchBar, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.lowercased()
        filteredArr = tasks.where { $0.title.contains(text, options: .caseInsensitive) || $0.address.contains(text, options: .caseInsensitive) }
        tableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier) as? SearchTableViewCell else { return UITableViewCell() }
        if let arr = filteredArr?[indexPath.row] {
            cell.title.text = "\(arr.id). \(arr.title)"
            cell.address.text = arr.address
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow?(filteredArr?[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}

