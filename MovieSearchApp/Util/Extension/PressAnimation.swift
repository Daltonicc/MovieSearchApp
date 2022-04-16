//
//  UIViewController+Extension.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/16.
//

import UIKit

func addPressAnimationToButton(_ viewToAnimate: UIView, completion: ((Bool) -> Void)?) {

    UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {

        viewToAnimate.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

    }) { _ in

        UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {

            viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)

        }, completion: completion)
    }
}
