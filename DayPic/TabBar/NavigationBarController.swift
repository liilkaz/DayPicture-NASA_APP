//
//  NavigationBarController.swift
//  DayPic
//
//  Created by Лилия Феодотова on 06.02.2024.
//

import UIKit

class NavigationBarController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .black
        navigationBar.isHidden = true
    }
    
}
