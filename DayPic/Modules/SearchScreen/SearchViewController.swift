//
//  SearchViewController.swift
//  DayPic
//
//  Created by Лилия Феодотова on 06.02.2024.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let searchList = UITableView()
    
    var resultList = [Item]()
    var isLoading = false
    
    private let appService = AppService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

private extension SearchViewController {
    func setupView() {
        view.backgroundColor = .black
        setupSearchBar()
        setupSearchList()
        
        view.addSubviews(searchBar, searchList)
        searchList.reloadData()
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "Найти"
        searchBar.barTintColor = .black
        searchBar.barStyle = .black
        searchBar.delegate = self
    }
    
    func setupSearchList() {
        searchList.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        
        searchList.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.reuseIdentifier)

        searchList.rowHeight = 200
        searchList.backgroundColor = .black
        searchList.delegate = self
        searchList.dataSource = self
        searchList.reloadData()
    }
    
    func setConstraint() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view).inset(20)
        }
        
        searchList.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.left.right.bottom.equalTo(view)
        }
    }
    
    func fetchSearchResult(req: String) {
        appService.fetchSearchPics(req: req) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let res):
                    guard let result =  res.collection?.items else {return}
                    self.resultList = result
                    self.searchList.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func transformModel(model: [Item]) -> [DayPictureModel] {
        var detailModel = [DayPictureModel]()
        model.forEach { item in
            if let title = item.data?.first?.title, let url = item.links?.first?.href, let explanation = item.data?.first?.description {
                detailModel.append(DayPictureModel(title: title, url: url, explanation: explanation))
            }
        }
        return detailModel
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return resultList.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.config(info: resultList[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as? LoadingCell else { return UITableViewCell() }
            cell.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailModel = transformModel(model: resultList)
        let vc = DetailViewController(detailModel: detailModel[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 20, !isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                //?
                DispatchQueue.main.async {
                    self.searchList.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        if !searchText.isEmpty {
            fetchSearchResult(req: searchText)
        } else {
            resultList.removeAll()
            searchList.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        resultList.removeAll()
        searchList.reloadData()

    }
}
