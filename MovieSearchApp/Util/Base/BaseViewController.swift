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
    }

    func setViewConfig() {
        view.backgroundColor = .white
    }

    func navigationItemConfig() {}
}
