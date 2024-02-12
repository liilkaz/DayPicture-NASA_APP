//
//  UIViewController + Extension.swift
//  DayPic
//
//  Created by Лилия Феодотова on 08.02.2024.
//

import UIKit

extension UIViewController {
    func setNavigationBar(title: String) {
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white,
         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .black.withAlphaComponent(1)
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
