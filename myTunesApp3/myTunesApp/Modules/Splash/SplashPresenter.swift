//
//  SplashPresenter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import Foundation

protocol SplashPresenterProtocol: AnyObject {
    var view: SplashViewProtocol? { get set }
    var interactor: SplashInteractorInputProtocol? { get set }
    var router: SplashRouterProtocol? { get set }

    func viewDidLoad()
}

class SplashPresenter: SplashPresenterProtocol, SplashInteractorOutputProtocol {
  weak var view: SplashViewProtocol?
  var interactor: SplashInteractorInputProtocol?
  var router: SplashRouterProtocol?
  
  init(view: SplashViewProtocol, interactor: SplashInteractorInputProtocol, router: SplashRouterProtocol) {
    self.view = view
    self.interactor = interactor
    self.router = router
  }
  
  func viewDidLoad() {
    interactor?.checkInternetConnection()
  }
  
  func internetStatus(isConnected: Bool) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if isConnected {
        if let view = self.view {
          self.router?.pushToSearchScreen(from: view)
        }
      } else {
        self.view?.showError()
      }
    }
  }
}
