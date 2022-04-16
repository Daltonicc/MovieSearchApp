//
//  PressAnimation.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/16.
//

import UIKit

func addPressAnimationToButton(scale: Double, _ viewToAnimate: UIView, completion: ((Bool) -> Void)?) {

    UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {

        viewToAnimate.transform = CGAffineTransform(scaleX: scale, y: scale)

    }) { _ in

        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {

            viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)

        }, completion: completion)
    }
}
