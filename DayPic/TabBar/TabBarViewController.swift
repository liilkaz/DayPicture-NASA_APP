//
//  TabBarViewController.swift
//  DayPic
//
//  Created by Лилия Феодотова on 06.02.2024.
//

import UIKit

enum Tabs: CaseIterable {
    case dayPic
    case search
}

enum TabsConfigure {
    static func setTitle(_ tab: Tabs) -> String {
        switch tab {
        case .dayPic:
            return "Фото дня"
        case .search:
            return "Поиск"
        }
    }
    
    static func setIcon(_ tab: Tabs) -> UIImage? {
        switch tab {
        case .dayPic:
            guard let icon = UIImage(systemName: "photo.on.rectangle.angled") else {return nil}
            return icon
        case .search:
            guard let icon = UIImage(systemName: "magnifyingglass") else {return nil}
            return icon
        }
    }
}

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        tabBar.barStyle = .black
        tabBar.backgroundColor = .black
        
        tabBar.tintColor = .white

        let controllers: [NavigationBarController] = Tabs.allCases.map { tab in
            let controller = NavigationBarController(rootViewController: getController(for: tab))
            
            controller.tabBarItem = UITabBarItem(title: TabsConfigure.setTitle(tab),
                                                 image: TabsConfigure.setIcon(tab)?.withRenderingMode(.alwaysOriginal),
                                       selectedImage: TabsConfigure.setIcon(tab))

            return controller
                                                     
        }
        setViewControllers(controllers, animated: false)
    }
    
    private func getController(for tab: Tabs) -> UIViewController {
        switch tab {
        case .dayPic: return DayPicViewController()
        case .search: return SearchViewController()
        }
    }
}
