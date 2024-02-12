//
//  LoadingReusableView.swift
//  DayPic
//
//  Created by Лилия Феодотова on 09.02.2024.
//

import UIKit
import SnapKit

final class LoadingReusableView: UICollectionReusableView {
    static var reuseIdentifier: String { "\(Self.self)" }
    
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    public func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
}

private extension LoadingReusableView {
    func setupView() {
        backgroundColor = .clear
        activityIndicator.color = .white
        addSubviews(activityIndicator)
        disableSubviewsTamic()
    }
    
    
    func setConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
}
