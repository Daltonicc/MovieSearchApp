//
//  UIViewController+Extension.swift
//  MovieSearchApp
//
//  Created by 박근보 on 2022/04/18.
//

import UIKit
import Network

extension UIViewController {
    private func noNetworkAlert() {
        let alert = UIAlertController(title: "인터넷 연결을 확인해주세요!", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    @discardableResult func monitorNetwork() -> Bool {

        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Network")
        var status = false

        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                status = true
                monitor.cancel()
                return
            } else {
                DispatchQueue.main.async {
                    self.noNetworkAlert()
                    status = false
                    monitor.cancel()
                    return
                }
            }
        }
        return status
    }
}
