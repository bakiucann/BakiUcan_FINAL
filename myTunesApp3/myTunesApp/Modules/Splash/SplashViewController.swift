//
//  SplashViewController.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit
import AlertPresentable

protocol SplashViewProtocol: AnyObject {
    var presenter: SplashPresenterProtocol? { get set }

    func showError()
}

class SplashViewController: UIViewController {
    var presenter: SplashPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
    }
}

extension SplashViewController: SplashViewProtocol {
  func showError() {
      showError(withMessage: "No Internet Connection. Please check your internet connection and try again.")
  }
}
