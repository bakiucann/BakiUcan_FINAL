//
//  SearchRouter.swift
//  myTunesApp
//
//  Created by Baki Uçan on 6.06.2023.
//

import UIKit

protocol SearchRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func pushToSongDetail(with song: Song)
}

class SearchRouter: SearchRouterProtocol {
    weak var view: UIViewController?

    static func createModule() -> UIViewController {
        let view = SearchViewController()
        let interactor = SearchInteractor()
        let router = SearchRouter()
        let presenter = SearchPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.view = view // view özelliğini atama

        return view
    }

    func pushToSongDetail(with song: Song) {
        guard let view = view else {
            return
        }
        let songDetailViewController = DetailRouter.createModule(with: song)
        view.navigationController?.pushViewController(songDetailViewController, animated: true)
    }
}
