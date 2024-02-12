//
//  SearchTableViewCell.swift
//  DayPic
//
//  Created by Лилия Феодотова on 08.02.2024.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {

    static var reuseIdentifier: String { "\(Self.self)" }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let imageSearchView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageSearchView.image = nil
        nameLabel.text = nil
    }
    
    public func config(info: Item) {
        nameLabel.text = info.data?.first?.title
        guard let imageUrl = info.links?.first?.href else { return }
        imageSearchView.kf.indicatorType = .activity
        imageSearchView.kf.setImage(with: URL(string: imageUrl), options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage])
        
    }
}

extension SearchTableViewCell {
    func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubviews(imageSearchView, nameLabel)
        contentView.disableSubviewsTamic()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageSearchView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageSearchView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageSearchView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageSearchView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.bottomAnchor.constraint(equalTo: imageSearchView.bottomAnchor, constant: -5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
