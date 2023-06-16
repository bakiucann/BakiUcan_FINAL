//
//  UIImage+Extension.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit

// MARK: - ImageLoading

protocol ImageLoading {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

extension UIImageView: ImageLoading {
    /// Loads an image from the specified URL asynchronously.
    /// - Parameters:
    ///   - url: The URL of the image to be loaded.
    ///   - completion: A closure to be executed when the image loading is completed. The closure will be called on the main queue.
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
