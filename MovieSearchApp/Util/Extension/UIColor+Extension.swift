//
//  UIColor+Extension.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/20.
//

import UIKit

extension UIColor {
    static var barButtonColor: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .white
            } else {
                return .black
            }
        }
    }

    static var favoirteListButtonColor: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return .systemGray
            } else {
                return .systemGray4
            }
        }
    }
}
