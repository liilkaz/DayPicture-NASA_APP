//
//  ViewController.swift
//  DayPic
//
//  Created by Лилия Феодотова on 06.02.2024.
//

import UIKit

enum Sections: Int, CaseIterable {
    case dayPic
    case archivePics
}

final class DayPicViewController: UIViewController {
    
    let sections: [Sections] = [.dayPic, .archivePics]
    var model = DayPictureModel(title: "", url: "", explanation: "")
    var archModel = [DayPictureModel]()
    
    var loadingView = LoadingReusableView()
    var isLoading = false
    
    private let appService = AppService()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(DayPicCollectionViewCell.self, forCellWithReuseIdentifier: DayPicCollectionViewCell.reuseIdentifier)
        
        view.register(LoadingReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingReusableView.reuseIdentifier)
        view.backgroundColor = .black
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        fecthArchData()
        setupView()
        setConstraints()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func fetchData() {
        appService.fetchDayPic { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    self.model = res
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fecthArchData() {
        appService.fetchArchPics { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let res):
                    res.forEach { item in
                        self.archModel.append(item)
                    }
                    self.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

private extension DayPicViewController {
    
    func setupView() {
        collectionView.collectionViewLayout = createLayout()
        view.addSubviews(collectionView)
        view.disableSubviewsTamic()
    }
    
    func setConstraints(){
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

extension DayPicViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .dayPic:
            return 1
        case .archivePics:
            return archModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .dayPic:
            return dayPicSection(collectionView, cellForItemAt: indexPath)
        case .archivePics:
            return archivePicsSection(collectionView, cellForItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sections[indexPath.section] {
        case .dayPic:
            let vc = DetailViewController(detailModel: model)
            navigationController?.pushViewController(vc, animated: true)
            
        case .archivePics:
            let vc = DetailViewController(detailModel: archModel[indexPath.row])
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func dayPicSection(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayPicCollectionViewCell.reuseIdentifier, for: indexPath) as? DayPicCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.config(info: model)
        return cell
    }
    
    func archivePicsSection(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayPicCollectionViewCell.reuseIdentifier, for: indexPath) as? DayPicCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.config(info: archModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 19, !self.isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
                    self.fecthArchData()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter else { return UICollectionReusableView() }
        
        let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: LoadingReusableView.reuseIdentifier,
            for: indexPath
        ) as! LoadingReusableView
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView.stopAnimating()
        }
    }
    
}

extension DayPicViewController: UICollectionViewDelegateFlowLayout {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Sections(rawValue: sectionIndex) else { return nil }
            let section = self.layoutSection(for: sectionKind, layoutEnvironment: layoutEnvironment)
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: config)
        return layout
    }
    
    func layoutSection(for section: Sections, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch section {
        case .dayPic:
            picLayout(numberOfColumns: 1)
        case .archivePics:
            picLayout(numberOfColumns: 2)
        }
    }
    
    private func picLayout(numberOfColumns: CGFloat) -> NSCollectionLayoutSection {
        let fraction: CGFloat = 1 / numberOfColumns
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fraction),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

