//
//  BaseViewController.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/15.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewConfig()
        navigationItemConfig()
        bind()
    }

    func setViewConfig() {
        view.backgroundColor = .white
    }

    func navigationItemConfig() {}
    func bind() {}
}
