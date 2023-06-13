//
//  UIImage+Extension.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit

protocol ImageLoading {
    func loadImage(from url: URL)
}

extension UIImageView: ImageLoading {
    func loadImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}

