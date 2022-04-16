//
//  DetailView.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/16.
//

import UIKit
import SnapKit
import WebKit

final class DetailView: BaseView {

    let movieView: MovieInfoView = {
        let view = MovieInfoView()
        return view
    }()
    let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    let separateView2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func setUpView() {

        addSubview(separateView)
        addSubview(movieView)
        addSubview(separateView2)
        addSubview(webView)
    }

    override func setUpConstraint() {

        separateView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(5)
        }
        movieView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(110)
        }
        separateView2.snp.makeConstraints { make in
            make.top.equalTo(movieView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(5)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(separateView2.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
