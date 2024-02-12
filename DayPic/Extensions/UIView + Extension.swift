//
//  UIView + Extension.swift
//  DayPic
//
//  Created by Лилия Феодотова on 06.02.2024.
//

import UIKit

extension UIView {
    func disableSubviewsTamic() {
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview(_:))
    }
}
