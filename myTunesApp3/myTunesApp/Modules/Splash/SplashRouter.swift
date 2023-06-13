//
//  SplashRouter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit

protocol SplashRouterProtocol: AnyObject {
    var viewController: SplashViewController? { get set }
    static func createModule() -> UIViewController
    func pushToSearchScreen(from view: SplashViewProtocol)
}

class SplashRouter: SplashRouterProtocol {
    weak var viewController: SplashViewController?

    static func createModule() -> UIViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let router = SplashRouter()
        let presenter = SplashPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }

  func pushToSearchScreen(from view: SplashViewProtocol) {
      let searchViewController = SearchRouter.createModule()
      let navigationController = UINavigationController(rootViewController: searchViewController)
      navigationController.modalPresentationStyle = .fullScreen
      viewController?.present(navigationController, animated: true, completion: nil)
  }

}
