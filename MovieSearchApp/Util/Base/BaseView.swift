//
//  BaseView.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import UIKit

class BaseView: UIView, ViewRepresentable {

    let backBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "chevron.left")
        barButton.tintColor = .barButtonColor
        return barButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpView() {}
    func setUpConstraint() {}
}
